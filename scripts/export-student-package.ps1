#Requires -Version 5.1
<#
.SYNOPSIS
  Export a whitelist-based student ZIP package from an explicit Git ref.

.DESCRIPTION
  Teacher / course maintainer only. Does not commit, push, or overwrite
  existing packages. See docs/STUDENT_PACKAGE_SPEC.md.
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$CourseState,

    [Parameter(Mandatory = $true)]
    [string]$Version,

    [Parameter(Mandatory = $true)]
    [string]$SourceRef
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message"
}

function Assert-Command {
    param([string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command not found: $Name"
    }
}

function Get-RelativePathUnix {
    param(
        [string]$BasePath,
        [string]$FullPath
    )
    $base = [System.IO.Path]::GetFullPath($BasePath).TrimEnd('\', '/')
    $full = [System.IO.Path]::GetFullPath($FullPath)
    if (-not $full.StartsWith($base, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Path is outside base: $FullPath"
    }
    $rel = $full.Substring($base.Length).TrimStart('\', '/')
    return ($rel -replace '\\', '/')
}

function Get-FileSha256Hex {
    param([string]$Path)
    return (Get-FileHash -Path $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

Write-Host "========================================"
Write-Host "Export Student Package"
Write-Host "========================================"
Write-Host "Repo:         $repoRoot"
Write-Host "CourseState:  $CourseState"
Write-Host "Version:      $Version"
Write-Host "SourceRef:    $SourceRef"

if ($CourseState -notmatch '^[a-z0-9][a-z0-9\-]*$') {
    throw "Invalid CourseState. Use lowercase letters, digits, hyphens (e.g. lesson-01-start)."
}

if ($Version -notmatch '^v\d+\.\d+\.\d+([.-][A-Za-z0-9.-]+)?$') {
    throw "Invalid Version. Use form vMAJOR.MINOR.PATCH (e.g. v0.1.0)."
}

Assert-Command "git"

$gitTop = (& git rev-parse --show-toplevel 2>$null)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($gitTop)) {
    throw "Not inside a Git repository."
}

$sourceCommit = (& git rev-parse --verify "$SourceRef^{commit}" 2>$null)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($sourceCommit)) {
    throw "Cannot resolve SourceRef to a commit: $SourceRef"
}
$sourceCommit = $sourceCommit.Trim()

Write-Host "SourceCommit: $sourceCommit"

# Whitelist paths relative to repo root (forward slashes). Must exist in SourceRef.
$whitelistPaths = @(
    "package.json",
    "package-lock.json",
    "vite.config.ts",
    "tsconfig.json",
    "index.html",
    "start-project.bat",
    "DESIGN.md",
    "src",
    "docs/COMPONENT_CATALOG.md",
    "docs/LESSON_01_GUIDE.md"
)

$templateRoot = Join-Path $repoRoot "student-package\templates"
$requiredTemplates = @(
    "START_HERE.md",
    "README.md",
    "CLAUDE.md",
    ".gitignore",
    "scripts\verify-student-project.ps1"
)

foreach ($templateRel in $requiredTemplates) {
    $templatePath = Join-Path $templateRoot $templateRel
    if (-not (Test-Path -LiteralPath $templatePath)) {
        throw "Missing student template: student-package/templates/$($templateRel -replace '\\','/')"
    }
}

foreach ($pathItem in $whitelistPaths) {
    & git cat-file -e "${sourceCommit}:$pathItem" 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Whitelist path missing in SourceRef ($SourceRef / $sourceCommit): $pathItem"
    }
}

$packageBaseName = "ai-business-prototype-$CourseState-$Version"
$artifactDir = Join-Path $repoRoot "artifacts\student-packages"
$zipPath = Join-Path $artifactDir "$packageBaseName.zip"
$zipShaPath = Join-Path $artifactDir "$packageBaseName.zip.sha256"

if (-not (Test-Path -LiteralPath $artifactDir)) {
    New-Item -ItemType Directory -Path $artifactDir -Force | Out-Null
}

if (Test-Path -LiteralPath $zipPath) {
    throw "Refusing to overwrite existing package: $zipPath"
}
if (Test-Path -LiteralPath $zipShaPath) {
    throw "Refusing to overwrite existing checksum: $zipShaPath"
}

$stagingRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-student-export-" + [guid]::NewGuid().ToString("N"))
$packageRoot = Join-Path $stagingRoot $packageBaseName
$archiveZip = Join-Path $stagingRoot "git-archive-subset.zip"

try {
    Write-Step "Creating staging directory"
    New-Item -ItemType Directory -Path $packageRoot -Force | Out-Null

    Write-Step "Extracting whitelist from git archive"
    $archiveArgs = @("archive", "--format=zip", "-o", $archiveZip, $sourceCommit) + $whitelistPaths
    & git @archiveArgs
    if ($LASTEXITCODE -ne 0) {
        throw "git archive failed."
    }

    Expand-Archive -LiteralPath $archiveZip -DestinationPath $packageRoot -Force

    Write-Step "Applying student templates (replace teacher docs)"
    Copy-Item -LiteralPath (Join-Path $templateRoot "START_HERE.md") -Destination (Join-Path $packageRoot "START_HERE.md") -Force
    Copy-Item -LiteralPath (Join-Path $templateRoot "README.md") -Destination (Join-Path $packageRoot "README.md") -Force
    Copy-Item -LiteralPath (Join-Path $templateRoot "CLAUDE.md") -Destination (Join-Path $packageRoot "CLAUDE.md") -Force
    Copy-Item -LiteralPath (Join-Path $templateRoot ".gitignore") -Destination (Join-Path $packageRoot ".gitignore") -Force

    $scriptsDir = Join-Path $packageRoot "scripts"
    if (-not (Test-Path -LiteralPath $scriptsDir)) {
        New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
    }
    Copy-Item -LiteralPath (Join-Path $templateRoot "scripts\verify-student-project.ps1") `
        -Destination (Join-Path $scriptsDir "verify-student-project.ps1") -Force

    # Safety: ensure teacher-only paths never leak even if whitelist changes
    $mustNotExist = @(
        "references",
        "CONTRIBUTING.md",
        "docs\COURSE_ROADMAP.md",
        "docs\LESSON_TEMPLATE.md",
        "docs\DESIGN_ALIGNMENT_AUDIT.md",
        "docs\DESIGN_ALIGNMENT_DECISIONS.md",
        "docs\DESIGN_ALIGNMENT_FINAL_REPORT.md",
        "scripts\verify-project.ps1",
        "scripts\export-student-package.ps1",
        "student-package",
        ".git",
        "node_modules",
        "dist",
        ".env"
    )
    foreach ($bad in $mustNotExist) {
        $badPath = Join-Path $packageRoot $bad
        if (Test-Path -LiteralPath $badPath) {
            throw "Export safety check failed; prohibited path present: $bad"
        }
    }

    Write-Step "Writing VERSION.txt"
    $exportTimestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $versionLines = @(
        "Package Name: $packageBaseName",
        "Course State: $CourseState",
        "Version: $Version",
        "Source Ref: $SourceRef",
        "Source Commit: $sourceCommit",
        "Export Timestamp (UTC): $exportTimestamp",
        "Generator: scripts/export-student-package.ps1",
        "Specification: docs/STUDENT_PACKAGE_SPEC.md"
    )
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllLines((Join-Path $packageRoot "VERSION.txt"), $versionLines, $utf8NoBom)

    Write-Step "Building PACKAGE_MANIFEST.txt and SHA256SUMS.txt"
    $allFiles = Get-ChildItem -LiteralPath $packageRoot -Recurse -File | Sort-Object FullName
    $manifestLines = New-Object System.Collections.Generic.List[string]
    $sumLines = New-Object System.Collections.Generic.List[string]

    foreach ($file in $allFiles) {
        $rel = Get-RelativePathUnix -BasePath $packageRoot -FullPath $file.FullName
        $manifestLines.Add($rel)
    }

    # Manifest first (without meta files that we are about to add... we include VERSION already)
    # Add manifest and sums themselves after computing file hashes for content files only.
    $contentFilesForHash = $allFiles

    foreach ($file in $contentFilesForHash) {
        $rel = Get-RelativePathUnix -BasePath $packageRoot -FullPath $file.FullName
        $hash = Get-FileSha256Hex -Path $file.FullName
        $sumLines.Add("$hash  $rel")
    }

    $manifestPath = Join-Path $packageRoot "PACKAGE_MANIFEST.txt"
    $sumsPath = Join-Path $packageRoot "SHA256SUMS.txt"

    # Final manifest includes all files currently present plus the two meta files we add
    $finalManifest = New-Object System.Collections.Generic.List[string]
    foreach ($line in $manifestLines) {
        $finalManifest.Add($line)
    }
    $finalManifest.Add("PACKAGE_MANIFEST.txt")
    $finalManifest.Add("SHA256SUMS.txt")
    $sortedManifest = $finalManifest | Sort-Object

    [System.IO.File]::WriteAllLines($manifestPath, $sortedManifest, $utf8NoBom)

    # SHA256SUMS covers every file except itself
    $sumLines.Add("$((Get-FileSha256Hex -Path $manifestPath))  PACKAGE_MANIFEST.txt")
    $sortedSums = $sumLines | Sort-Object { ($_ -split '  ', 2)[1] }
    [System.IO.File]::WriteAllLines($sumsPath, $sortedSums, $utf8NoBom)

    # Re-verify manifest lists exactly the files on disk
    $onDisk = Get-ChildItem -LiteralPath $packageRoot -Recurse -File | ForEach-Object {
        Get-RelativePathUnix -BasePath $packageRoot -FullPath $_.FullName
    } | Sort-Object
    $manifestOnDisk = Get-Content -LiteralPath $manifestPath -Encoding UTF8 | Where-Object { $_.Trim() -ne "" } | Sort-Object
    $diskSet = [System.Collections.Generic.HashSet[string]]::new([string[]]$onDisk, [StringComparer]::Ordinal)
    $manSet = [System.Collections.Generic.HashSet[string]]::new([string[]]$manifestOnDisk, [StringComparer]::Ordinal)
    if ($diskSet.Count -ne $manSet.Count -or -not $diskSet.SetEquals($manSet)) {
        throw "PACKAGE_MANIFEST.txt does not match staged file list."
    }

    Write-Step "Creating ZIP (single top-level directory)"
    # Compress-Archive includes the folder name as root entry when packaging the folder
    Compress-Archive -Path $packageRoot -DestinationPath $zipPath -CompressionLevel Optimal
    if (-not (Test-Path -LiteralPath $zipPath)) {
        throw "ZIP was not created: $zipPath"
    }

    Write-Step "Writing external ZIP SHA256"
    $zipHash = Get-FileSha256Hex -Path $zipPath
    $shaContent = "$zipHash  $packageBaseName.zip"
    [System.IO.File]::WriteAllText($zipShaPath, $shaContent + [Environment]::NewLine, $utf8NoBom)

    $zipInfo = Get-Item -LiteralPath $zipPath
    $fileCount = (Get-ChildItem -LiteralPath $packageRoot -Recurse -File).Count

    Write-Host ""
    Write-Host "========================================"
    Write-Host "Export completed (local candidate only)"
    Write-Host "========================================"
    Write-Host "Package:       $packageBaseName"
    Write-Host "Course State:  $CourseState"
    Write-Host "Version:       $Version"
    Write-Host "Source Ref:    $SourceRef"
    Write-Host "Source Commit: $sourceCommit"
    Write-Host "ZIP:           $zipPath"
    Write-Host "ZIP Size:      $($zipInfo.Length) bytes"
    Write-Host "ZIP SHA256:    $zipHash"
    Write-Host "Files in pkg:  $fileCount"
    Write-Host "Checksum:      $zipShaPath"
    Write-Host ""
    Write-Host "This package is NOT automatically a formal release."
    Write-Host "Validate per docs/STUDENT_PACKAGE_SPEC.md before distribution."
    Write-Host "Did not commit, push, or upload."
}
finally {
    if (Test-Path -LiteralPath $stagingRoot) {
        Remove-Item -LiteralPath $stagingRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
