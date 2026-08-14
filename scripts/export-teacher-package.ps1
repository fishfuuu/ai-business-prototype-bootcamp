#Requires -Version 5.1
<#
.SYNOPSIS
  Export a teacher classroom-delivery bundle from an explicit Git ref.

.DESCRIPTION
  Teacher / course maintainer only. Packages the full set of teacher-facing
  course content (10 teacher plans, 10 learner guides, interactive HTML
  courseware, course roadmap, course fixtures, teaching skills and the
  prototype base) from the same Source Commit via git archive.
  Uncommitted working-tree changes never enter the ZIP.
  Does not commit, push, or overwrite existing packages.
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Version,
    [string]$SourceRef = "HEAD",
    [string]$OutputDirectory
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

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
    param([string]$BasePath, [string]$FullPath)
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

function Test-GitPathExists {
    param([string]$Commit, [string]$GitPath)
    $prevEap = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $null = & git cat-file -e "${Commit}:${GitPath}" 2>&1
        return ($LASTEXITCODE -eq 0)
    }
    finally {
        $ErrorActionPreference = $prevEap
    }
}

function Assert-GitPathExists {
    param([string]$Commit, [string]$GitPath, [string]$SourceRefLabel)
    if (-not (Test-GitPathExists -Commit $Commit -GitPath $GitPath)) {
        throw "Required path missing in SourceRef ($SourceRefLabel / $Commit): $GitPath"
    }
}

function Invoke-PackageSafetyCheck {
    param([string]$PackageRoot, [string]$Phase)
    $prohibitedPaths = @(
        ".git",
        ".github",
        ".mcp.json",
        ".agents",
        "references",
        "node_modules",
        "dist",
        ".vite",
        "artifacts",
        "archive",
        "student-package",
        "CONTRIBUTING.md",
        "lessons\TEN_LESSON_FROZEN_BASELINE.md",
        "scripts"
    )
    foreach ($bad in $prohibitedPaths) {
        $badPath = Join-Path $PackageRoot $bad
        if (Test-Path -LiteralPath $badPath) {
            throw "Safety check ($Phase) failed; prohibited path present: $bad"
        }
    }
    $allFiles = Get-ChildItem -LiteralPath $PackageRoot -Recurse -File -Force
    foreach ($file in $allFiles) {
        $name = $file.Name
        $rel = Get-RelativePathUnix -BasePath $PackageRoot -FullPath $file.FullName
        if ($name -eq ".env.example") { continue }
        if ($name -eq ".env" -or $name -like ".env.*") {
            throw "Safety check ($Phase) failed; prohibited env file: $rel"
        }
        if ($name -like "*.pem" -or $name -like "*.key" -or $name -like "*.pfx" -or $name -like "*.p12" -or $name -eq "id_rsa") {
            throw "Safety check ($Phase) failed; prohibited credential file: $rel"
        }
    }
}

Write-Host "========================================"
Write-Host "Export Teacher Package"
Write-Host "========================================"

if ($Version -notmatch '^v\d+\.\d+\.\d+$') {
    throw "Invalid Version. Must match ^v\d+\.\d+\.\d+$ (e.g. v0.1.0)."
}

Assert-Command "git"

$repoRoot = Split-Path -Parent $PSScriptRoot
$gitTopRaw = (& git rev-parse --show-toplevel 2>$null)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($gitTopRaw)) {
    throw "Not inside a Git repository."
}
$gitTop = [System.IO.Path]::GetFullPath($gitTopRaw.Trim())
if ($gitTop.TrimEnd('\') -ne $repoRoot.TrimEnd('\')) {
    throw "Git toplevel ($gitTop) does not match script repo root ($repoRoot). Refuse to run."
}

$sourceCommit = (& git rev-parse --verify "$SourceRef^{commit}" 2>$null)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($sourceCommit)) {
    throw "Cannot resolve SourceRef to a commit: $SourceRef"
}
$sourceCommit = $sourceCommit.Trim()
Write-Host "SourceCommit: $sourceCommit"

$packageBaseName = "ai-business-prototype-teacher-bundle-$Version"

$whitelist = @(
    "lessons/LESSON_01_GUIDE.md",
    "lessons/LESSON_02_GUIDE.md",
    "lessons/LESSON_03_GUIDE.md",
    "lessons/LESSON_04_GUIDE.md",
    "lessons/LESSON_05_GUIDE.md",
    "lessons/LESSON_06_GUIDE.md",
    "lessons/LESSON_07_GUIDE.md",
    "lessons/LESSON_08_GUIDE.md",
    "lessons/LESSON_09_GUIDE.md",
    "lessons/LESSON_10_GUIDE.md",
    "lessons/LESSON_01_TEACHER_PLAN.md",
    "lessons/LESSON_02_TEACHER_PLAN.md",
    "lessons/LESSON_03_TEACHER_PLAN.md",
    "lessons/LESSON_04_TEACHER_PLAN.md",
    "lessons/LESSON_05_TEACHER_PLAN.md",
    "lessons/LESSON_06_TEACHER_PLAN.md",
    "lessons/LESSON_07_TEACHER_PLAN.md",
    "lessons/LESSON_08_TEACHER_PLAN.md",
    "lessons/LESSON_09_TEACHER_PLAN.md",
    "lessons/LESSON_10_TEACHER_PLAN.md",
    "lessons/html",
    "lessons/COURSE_ROADMAP.md",
    "lessons/COURSE_ROADMAP_STUDENT.md",
    "course-fixtures",
    ".claude/skills",
    ".claude/agents",
    "GLOSSARY.md",
    "CLAUDE.md",
    "DESIGN.md",
    "package.json",
    "package-lock.json",
    "vite.config.ts",
    "tsconfig.json",
    "index.html",
    "start-project.bat",
    "src",
    ".gitignore"
)

foreach ($p in $whitelist) {
    Assert-GitPathExists -Commit $sourceCommit -GitPath $p -SourceRefLabel $SourceRef
}

if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $artifactDir = Join-Path $repoRoot "artifacts\teacher-packages"
} elseif ([System.IO.Path]::IsPathRooted($OutputDirectory)) {
    $artifactDir = [System.IO.Path]::GetFullPath($OutputDirectory)
} else {
    $artifactDir = [System.IO.Path]::GetFullPath((Join-Path $repoRoot $OutputDirectory))
}

$zipPath = Join-Path $artifactDir "$packageBaseName.zip"
$zipShaPath = Join-Path $artifactDir "$packageBaseName.zip.sha256"
if (-not (Test-Path -LiteralPath $artifactDir)) {
    New-Item -ItemType Directory -Path $artifactDir -Force | Out-Null
}
if (Test-Path -LiteralPath $zipPath) { throw "Refusing to overwrite existing package: $zipPath" }
if (Test-Path -LiteralPath $zipShaPath) { throw "Refusing to overwrite existing checksum: $zipShaPath" }

$stagingRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-teacher-export-" + [guid]::NewGuid().ToString("N"))
$snapshotDir = Join-Path $stagingRoot "snapshot"
$packageRoot = Join-Path $stagingRoot $packageBaseName
$archiveZip = Join-Path $stagingRoot "source-archive.zip"
$exportSucceeded = $false
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

try {
    Write-Step "Creating staging directories"
    New-Item -ItemType Directory -Path $snapshotDir -Force | Out-Null
    New-Item -ItemType Directory -Path $packageRoot -Force | Out-Null

    Write-Step "Extracting Source Commit snapshot via git archive"
    $archiveArgs = @("archive", "--format=zip", "-o", $archiveZip, $sourceCommit) + @($whitelist)
    & git @archiveArgs
    if ($LASTEXITCODE -ne 0) { throw "git archive failed." }
    Expand-Archive -LiteralPath $archiveZip -DestinationPath $snapshotDir -Force

    Write-Step "Copying whitelist from snapshot"
    foreach ($p in $whitelist) {
        $src = Join-Path $snapshotDir ($p -replace '/', '\')
        $dst = Join-Path $packageRoot ($p -replace '/', '\')
        if (-not (Test-Path -LiteralPath $src)) { throw "Snapshot missing expected path: $p" }
        $dstParent = Split-Path -Parent $dst
        if (-not (Test-Path -LiteralPath $dstParent)) { New-Item -ItemType Directory -Path $dstParent -Force | Out-Null }
        if ((Get-Item -LiteralPath $src).PSIsContainer) {
            Copy-Item -LiteralPath $src -Destination $dst -Recurse -Force
        } else {
            Copy-Item -LiteralPath $src -Destination $dst -Force
        }
    }

    Write-Step "Safety check (before metadata)"
    Invoke-PackageSafetyCheck -PackageRoot $packageRoot -Phase "pre-metadata"

    Write-Step "Writing VERSION.txt"
    $builtAtUtc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $versionLines = @(
        "Package: AI Business Prototype Teacher Bundle",
        "Version: $Version",
        "Source Ref: $SourceRef",
        "Source Commit: $sourceCommit",
        "Built At UTC: $builtAtUtc",
        "Delivery Mode: ZIP teacher classroom bundle"
    )
    [System.IO.File]::WriteAllLines((Join-Path $packageRoot "VERSION.txt"), $versionLines, $utf8NoBom)

    Write-Step "Building PACKAGE_MANIFEST.txt and SHA256SUMS.txt (Closed-Set Contract)"
    $existingFiles = Get-ChildItem -LiteralPath $packageRoot -Recurse -File | Sort-Object FullName
    $manifestLines = New-Object System.Collections.Generic.List[string]
    foreach ($file in $existingFiles) {
        $manifestLines.Add((Get-RelativePathUnix -BasePath $packageRoot -FullPath $file.FullName))
    }
    $manifestLines.Add("PACKAGE_MANIFEST.txt")
    $manifestLines.Add("SHA256SUMS.txt")
    [System.IO.File]::WriteAllLines((Join-Path $packageRoot "PACKAGE_MANIFEST.txt"), ($manifestLines | Sort-Object), $utf8NoBom)

    $sumLines = New-Object System.Collections.Generic.List[string]
    $filesForSha = Get-ChildItem -LiteralPath $packageRoot -Recurse -File | Where-Object { $_.Name -ne "SHA256SUMS.txt" } | Sort-Object FullName
    foreach ($file in $filesForSha) {
        $rel = Get-RelativePathUnix -BasePath $packageRoot -FullPath $file.FullName
        $sumLines.Add("$(Get-FileSha256Hex -Path $file.FullName)  $rel")
    }
    [System.IO.File]::WriteAllLines((Join-Path $packageRoot "SHA256SUMS.txt"), $sumLines, $utf8NoBom)

    $actualDisk = @(Get-ChildItem -LiteralPath $packageRoot -Recurse -File | ForEach-Object { Get-RelativePathUnix -BasePath $packageRoot -FullPath $_.FullName } | Sort-Object)
    $declared = @(Get-Content -Path (Join-Path $packageRoot "PACKAGE_MANIFEST.txt") | Sort-Object)
    if (($actualDisk -join "`n") -ne ($declared -join "`n")) {
        throw "Teacher package export assertion failed: Disk files set does not equal PACKAGE_MANIFEST.txt!"
    }

    Write-Step "Safety check (after metadata)"
    Invoke-PackageSafetyCheck -PackageRoot $packageRoot -Phase "post-metadata"

    Write-Step "Compressing to ZIP"
    Compress-Archive -LiteralPath $packageRoot -DestinationPath $zipPath -CompressionLevel Optimal

    Write-Step "Writing ZIP checksum"
    $zipHash = Get-FileSha256Hex -Path $zipPath
    [System.IO.File]::WriteAllText($zipShaPath, "$zipHash  $packageBaseName.zip`n", $utf8NoBom)

    $exportSucceeded = $true
    Write-Step "Export Complete"
    Write-Host "ZIP:    $zipPath"
    Write-Host "SHA256: $zipShaPath ($zipHash)"
}
finally {
    if (-not $exportSucceeded) {
        if (Test-Path -LiteralPath $zipPath) { Remove-Item -LiteralPath $zipPath -Force -ErrorAction SilentlyContinue }
        if (Test-Path -LiteralPath $zipShaPath) { Remove-Item -LiteralPath $zipShaPath -Force -ErrorAction SilentlyContinue }
    }
    if (Test-Path -LiteralPath $stagingRoot) {
        Remove-Item -LiteralPath $stagingRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}