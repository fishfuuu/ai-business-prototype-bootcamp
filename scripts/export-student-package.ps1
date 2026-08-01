#Requires -Version 5.1
<#
.SYNOPSIS
  Export a whitelist-based student ZIP package from an explicit Git ref.

.DESCRIPTION
  Teacher / course maintainer only. All package content (runtime files and
  learner templates) is taken from the same Source Commit via git archive.
  Uncommitted working-tree changes never enter the ZIP.
  Does not commit, push, or overwrite existing packages.
  See docs/STUDENT_PACKAGE_SPEC.md.
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$CourseState,

    [Parameter(Mandatory = $true)]
    [string]$Version,

    [string]$SourceRef = "HEAD",

    [string]$OutputDirectory
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

function Test-GitPathExists {
    param(
        [string]$Commit,
        [string]$GitPath
    )
    # git writes "path does not exist" to stderr; do not let that become a terminating error.
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
    param(
        [string]$Commit,
        [string]$GitPath,
        [string]$SourceRefLabel
    )
    if (-not (Test-GitPathExists -Commit $Commit -GitPath $GitPath)) {
        throw "Required path missing in SourceRef ($SourceRefLabel / $Commit): $GitPath"
    }
}

function Invoke-PackageSafetyCheck {
    param(
        [string]$PackageRoot,
        [string]$Phase
    )

    $prohibitedPaths = @(
        ".git",
        ".github",
        "references",
        "node_modules",
        "dist",
        ".vite",
        "artifacts",
        "student-package",
        "CONTRIBUTING.md",
        "scripts\verify-project.ps1",
        "scripts\export-student-package.ps1",
        "docs\COURSE_ROADMAP.md",
        "docs\LESSON_TEMPLATE.md",
        "docs\主管 AI 原型制作训练营.md",
        "docs\DESIGN_ALIGNMENT_AUDIT.md",
        "docs\DESIGN_ALIGNMENT_DECISIONS.md",
        "docs\DESIGN_ALIGNMENT_FINAL_REPORT.md"
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

        if ($name -eq ".env.example") {
            continue
        }

        if ($name -eq ".env" -or $name -like ".env.*" ) {
            throw "Safety check ($Phase) failed; prohibited env file: $rel"
        }

        if ($name -like "*.pem" -or $name -like "*.key" -or $name -like "*.pfx" -or $name -like "*.p12" -or $name -eq "id_rsa") {
            throw "Safety check ($Phase) failed; prohibited credential file: $rel"
        }
    }
}

function Invoke-SensitiveContentScan {
    param(
        [string]$PackageRoot
    )

    $scanExtensions = @(
        ".md", ".txt", ".json", ".ts", ".vue", ".js", ".scss", ".css",
        ".html", ".bat", ".ps1", ".gitignore"
    )

    # High-confidence credential rules (all scanned text types).
    $credentialRules = @(
        @{ Name = "PEM_PRIVATE_KEY"; Pattern = '-----BEGIN PRIVATE KEY-----' },
        @{ Name = "RSA_PRIVATE_KEY"; Pattern = '-----BEGIN RSA PRIVATE KEY-----' },
        @{ Name = "GITHUB_PAT"; Pattern = 'github_pat_' },
        @{ Name = "GITHUB_GHP_TOKEN"; Pattern = 'ghp_' },
        @{ Name = "AWS_ACCESS_KEY_ID"; Pattern = 'AKIA[0-9A-Z]{16}' },
        @{ Name = "OPENAI_STYLE_SK"; Pattern = 'sk-[A-Za-z0-9]{20,}' }
    )

    # Teacher-only content rules scan all supported text types.
    # TEACHER_CONTRIBUTING allows exactly one path exception: the student
    # verification script may list CONTRIBUTING.md as a prohibited path.
    $teacherContentRules = @(
        @{
            Name = "TEACHER_FINANCE_PATH"
            Pattern = 'C:\\Users\\Administrator\\Desktop\\财务经营分析系统'
            ExcludedPaths = @()
        },
        @{
            Name = "TEACHER_REPO_SLUG"
            Pattern = 'fishfuuu/ai-business-prototype-training'
            ExcludedPaths = @()
        },
        @{
            Name = "TEACHER_GIT_PULL_MAIN"
            Pattern = 'git pull --ff-only origin main'
            ExcludedPaths = @()
        },
        @{
            Name = "TEACHER_COURSE_BRANCH_PATTERN"
            Pattern = 'course/lesson-XX-'
            ExcludedPaths = @()
        },
        @{
            Name = "TEACHER_CONTRIBUTING"
            Pattern = 'CONTRIBUTING\.md'
            ExcludedPaths = @("scripts/verify-student-project.ps1")
        }
    )

    $files = Get-ChildItem -LiteralPath $PackageRoot -Recurse -File -Force | Where-Object {
        $ext = $_.Extension.ToLowerInvariant()
        ($scanExtensions -contains $ext) -or ($_.Name -eq ".gitignore")
    }

    foreach ($file in $files) {
        $rel = Get-RelativePathUnix -BasePath $PackageRoot -FullPath $file.FullName
        $text = [System.IO.File]::ReadAllText($file.FullName)

        foreach ($rule in $credentialRules) {
            if ($text -match $rule.Pattern) {
                throw "Sensitive content scan failed in '$rel' (rule: $($rule.Name))."
            }
        }

        foreach ($rule in $teacherContentRules) {
            $excluded = @($rule.ExcludedPaths)
            if ($excluded -contains $rel) {
                continue
            }
            if ($text -match $rule.Pattern) {
                throw "Sensitive content scan failed in '$rel' (rule: $($rule.Name))."
            }
        }
    }
}

$repoRoot = [System.IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
Set-Location $repoRoot

Write-Host "========================================"
Write-Host "Export Student Package"
Write-Host "========================================"
Write-Host "Repo:         $repoRoot"
Write-Host "CourseState:  $CourseState"
Write-Host "Version:      $Version"
Write-Host "SourceRef:    $SourceRef"

if ($CourseState -notmatch '^lesson-\d{2}-(start|complete)$') {
    throw "Invalid CourseState. Must match ^lesson-\d{2}-(start|complete)$ (e.g. lesson-01-start)."
}

if ($Version -notmatch '^v\d+\.\d+\.\d+$') {
    throw "Invalid Version. Must match ^v\d+\.\d+\.\d+$ (e.g. v0.1.0)."
}

Assert-Command "git"

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

# Runtime whitelist (must exist in Source Commit)
$runtimeWhitelist = @(
    "package.json",
    "package-lock.json",
    "vite.config.ts",
    "tsconfig.json",
    "index.html",
    "start-project.bat",
    "DESIGN.md",
    "src",
    "docs/COMPONENT_CATALOG.md",
    "docs/LESSON_01_GUIDE.md",
    "docs/LESSON_01_AI_BASICS.md",
    "docs/assets/lesson-01/lesson-flow.png",
    "docs/assets/lesson-01/page-layout.png",
    "docs/assets/lesson-01/component-map.png",
    "docs/assets/lesson-01/first-cohort-example.png"
)

$requiredTemplates = @(
    "student-package/templates/START_HERE.md",
    "student-package/templates/README.md",
    "student-package/templates/CLAUDE.md",
    "student-package/templates/.gitignore",
    "student-package/templates/scripts/verify-student-project.ps1"
)

foreach ($pathItem in $runtimeWhitelist) {
    Assert-GitPathExists -Commit $sourceCommit -GitPath $pathItem -SourceRefLabel $SourceRef
}

foreach ($templatePath in $requiredTemplates) {
    Assert-GitPathExists -Commit $sourceCommit -GitPath $templatePath -SourceRefLabel $SourceRef
}

$archivePaths = [System.Collections.Generic.List[string]]::new()
foreach ($p in $runtimeWhitelist) { $archivePaths.Add($p) }
$archivePaths.Add("student-package/templates")

$publicExists = Test-GitPathExists -Commit $sourceCommit -GitPath "public"
if ($publicExists) {
    Write-Host "Optional path present in Source Commit: public"
    $archivePaths.Add("public")
}

if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $artifactDir = Join-Path $repoRoot "artifacts\student-packages"
}
elseif ([System.IO.Path]::IsPathRooted($OutputDirectory)) {
    $artifactDir = [System.IO.Path]::GetFullPath($OutputDirectory)
}
else {
    $artifactDir = [System.IO.Path]::GetFullPath((Join-Path $repoRoot $OutputDirectory))
}

$packageBaseName = "ai-business-prototype-$CourseState-$Version"
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
    $archiveArgs = @("archive", "--format=zip", "-o", $archiveZip, $sourceCommit) + @($archivePaths.ToArray())
    & git @archiveArgs
    if ($LASTEXITCODE -ne 0) {
        throw "git archive failed."
    }

    Expand-Archive -LiteralPath $archiveZip -DestinationPath $snapshotDir -Force

    Write-Step "Copying runtime whitelist from snapshot"
    foreach ($pathItem in $runtimeWhitelist) {
        $src = Join-Path $snapshotDir ($pathItem -replace '/', '\')
        $dst = Join-Path $packageRoot ($pathItem -replace '/', '\')
        if (-not (Test-Path -LiteralPath $src)) {
            throw "Snapshot missing expected path: $pathItem"
        }
        $dstParent = Split-Path -Parent $dst
        if (-not (Test-Path -LiteralPath $dstParent)) {
            New-Item -ItemType Directory -Path $dstParent -Force | Out-Null
        }
        if ((Get-Item -LiteralPath $src).PSIsContainer) {
            Copy-Item -LiteralPath $src -Destination $dst -Recurse -Force
        }
        else {
            Copy-Item -LiteralPath $src -Destination $dst -Force
        }
    }

    if ($publicExists) {
        $publicSrc = Join-Path $snapshotDir "public"
        $publicDst = Join-Path $packageRoot "public"
        if (Test-Path -LiteralPath $publicSrc) {
            Copy-Item -LiteralPath $publicSrc -Destination $publicDst -Recurse -Force
        }
    }

    Write-Step "Applying student templates from snapshot (same Source Commit)"
    $templateSnap = Join-Path $snapshotDir "student-package\templates"
    $templateMap = @(
        @{ Src = "START_HERE.md"; Dst = "START_HERE.md" },
        @{ Src = "README.md"; Dst = "README.md" },
        @{ Src = "CLAUDE.md"; Dst = "CLAUDE.md" },
        @{ Src = ".gitignore"; Dst = ".gitignore" },
        @{ Src = "scripts\verify-student-project.ps1"; Dst = "scripts\verify-student-project.ps1" }
    )

    foreach ($item in $templateMap) {
        $src = Join-Path $templateSnap $item.Src
        $dst = Join-Path $packageRoot $item.Dst
        if (-not (Test-Path -LiteralPath $src)) {
            throw "Snapshot missing template: student-package/templates/$($item.Src -replace '\\','/')"
        }
        $dstParent = Split-Path -Parent $dst
        if (-not (Test-Path -LiteralPath $dstParent)) {
            New-Item -ItemType Directory -Path $dstParent -Force | Out-Null
        }
        Copy-Item -LiteralPath $src -Destination $dst -Force
    }

    # student-package must never remain in the final package
    $leakedStudentPackage = Join-Path $packageRoot "student-package"
    if (Test-Path -LiteralPath $leakedStudentPackage) {
        Remove-Item -LiteralPath $leakedStudentPackage -Recurse -Force
    }

    Write-Step "Safety check (before metadata)"
    Invoke-PackageSafetyCheck -PackageRoot $packageRoot -Phase "pre-metadata"

    Write-Step "Writing VERSION.txt"
    $builtAtUtc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $versionLines = @(
        "Package: AI Business Prototype Starter",
        "Course State: $CourseState",
        "Version: $Version",
        "Source Ref: $SourceRef",
        "Source Commit: $sourceCommit",
        "Built At UTC: $builtAtUtc",
        "Git Required: No",
        "Delivery Mode: ZIP learner package"
    )
    [System.IO.File]::WriteAllLines((Join-Path $packageRoot "VERSION.txt"), $versionLines, $utf8NoBom)

    Write-Step "Building PACKAGE_MANIFEST.txt and SHA256SUMS.txt"
    $allFiles = Get-ChildItem -LiteralPath $packageRoot -Recurse -File | Sort-Object FullName
    $manifestLines = New-Object System.Collections.Generic.List[string]
    $sumLines = New-Object System.Collections.Generic.List[string]

    foreach ($file in $allFiles) {
        $rel = Get-RelativePathUnix -BasePath $packageRoot -FullPath $file.FullName
        $manifestLines.Add($rel)
        $hash = Get-FileSha256Hex -Path $file.FullName
        $sumLines.Add("$hash  $rel")
    }

    $manifestPath = Join-Path $packageRoot "PACKAGE_MANIFEST.txt"
    $sumsPath = Join-Path $packageRoot "SHA256SUMS.txt"

    $finalManifest = New-Object System.Collections.Generic.List[string]
    foreach ($line in $manifestLines) { $finalManifest.Add($line) }
    $finalManifest.Add("PACKAGE_MANIFEST.txt")
    $finalManifest.Add("SHA256SUMS.txt")
    $sortedManifest = $finalManifest | Sort-Object
    [System.IO.File]::WriteAllLines($manifestPath, $sortedManifest, $utf8NoBom)

    $sumLines.Add("$((Get-FileSha256Hex -Path $manifestPath))  PACKAGE_MANIFEST.txt")
    $sortedSums = $sumLines | Sort-Object { ($_ -split '  ', 2)[1] }
    [System.IO.File]::WriteAllLines($sumsPath, $sortedSums, $utf8NoBom)

    $onDisk = Get-ChildItem -LiteralPath $packageRoot -Recurse -File | ForEach-Object {
        Get-RelativePathUnix -BasePath $packageRoot -FullPath $_.FullName
    } | Sort-Object
    $manifestOnDisk = Get-Content -LiteralPath $manifestPath -Encoding UTF8 | Where-Object { $_.Trim() -ne "" } | Sort-Object
    $diskSet = [System.Collections.Generic.HashSet[string]]::new([string[]]$onDisk, [StringComparer]::Ordinal)
    $manSet = [System.Collections.Generic.HashSet[string]]::new([string[]]$manifestOnDisk, [StringComparer]::Ordinal)
    if ($diskSet.Count -ne $manSet.Count -or -not $diskSet.SetEquals($manSet)) {
        throw "PACKAGE_MANIFEST.txt does not match staged file list."
    }

    Write-Step "Safety check (after metadata)"
    Invoke-PackageSafetyCheck -PackageRoot $packageRoot -Phase "post-metadata"

    Write-Step "High-confidence sensitive content scan"
    Invoke-SensitiveContentScan -PackageRoot $packageRoot

    Write-Step "Creating ZIP (single top-level directory)"
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

    $exportSucceeded = $true

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
    Write-Host "Output Dir:    $artifactDir"
    Write-Host ""
    Write-Host "This package is NOT automatically a formal release."
    Write-Host "Validate per docs/STUDENT_PACKAGE_SPEC.md before distribution."
    Write-Host "Did not commit, push, or upload."
}
finally {
    # Targets were proven absent at start; if export failed, any existing ZIP/sha
    # at those paths was produced by this run and must be removed.
    if (-not $exportSucceeded) {
        if (Test-Path -LiteralPath $zipPath) {
            Remove-Item -LiteralPath $zipPath -Force -ErrorAction SilentlyContinue
            Write-Host "Removed incomplete ZIP created this run: $zipPath"
        }
        if (Test-Path -LiteralPath $zipShaPath) {
            Remove-Item -LiteralPath $zipShaPath -Force -ErrorAction SilentlyContinue
            Write-Host "Removed incomplete checksum created this run: $zipShaPath"
        }
    }

    if (Test-Path -LiteralPath $stagingRoot) {
        Remove-Item -LiteralPath $stagingRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
