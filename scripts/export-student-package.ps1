#Requires -Version 5.1
<#
.SYNOPSIS
  Export a whitelist-based student ZIP package from an explicit Git ref.

.DESCRIPTION
  Teacher / course maintainer only. All package content (runtime files and
  learner templates) is taken from the same Source Commit via git archive.
  Uncommitted working-tree changes never enter the ZIP.
  Does not commit, push, or overwrite existing packages.
  See docs/STUDENT_PACKAGE_SPEC.md and docs/LESSON_02_MATERIALS_PACKAGE_ADDENDUM.md.
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$CourseState,

    [Parameter(Mandatory = $true)]
    [string]$Version,

    [string]$SourceRef = "HEAD",

    [string]$OutputDirectory,

    [string]$PackageProfile
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

function Get-NormalizedContentSha256Hex {
    param([string]$Path)
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    if ($text -match '\r\n') {
        $text = $text -replace "`r`n", "`n"
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
    }
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $hashBytes = $sha256.ComputeHash($bytes)
    return [System.BitConverter]::ToString($hashBytes).Replace('-', '').ToLowerInvariant()
}

function Test-GitPathExists {
    param(
        [string]$Commit,
        [string]$GitPath
    )
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
        "course-fixtures",
        "fixture-manifest.json",
        "CONTRIBUTING.md",
        "scripts\verify-project.ps1",
        "scripts\export-student-package.ps1",
        "scripts\export-lesson-materials.ps1",
        "scripts\install-lesson-materials.ps1",
        "docs\COURSE_ROADMAP.md",
        "docs\LESSON_TEMPLATE.md",
        "docs\LESSON_01_TEACHER_PLAN.md",
        "docs\LESSON_02_TEACHER_PLAN.md",
        "docs\LESSON_02_MATERIALS_PACKAGE_ADDENDUM.md",
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

    $credentialRules = @(
        @{ Name = "PEM_PRIVATE_KEY"; Pattern = '-----BEGIN PRIVATE KEY-----' },
        @{ Name = "RSA_PRIVATE_KEY"; Pattern = '-----BEGIN RSA PRIVATE KEY-----' },
        @{ Name = "GITHUB_PAT"; Pattern = 'github_pat_' },
        @{ Name = "GITHUB_GHP_TOKEN"; Pattern = 'ghp_' },
        @{ Name = "AWS_ACCESS_KEY_ID"; Pattern = 'AKIA[0-9A-Z]{16}' },
        @{ Name = "OPENAI_STYLE_SK"; Pattern = 'sk-[A-Za-z0-9]{20,}' }
    )

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
Write-Host "Repo:           $repoRoot"
Write-Host "CourseState:    $CourseState"
Write-Host "PackageProfile: $PackageProfile"
Write-Host "Version:        $Version"
Write-Host "SourceRef:      $SourceRef"

# Strictly restore original CourseState regex contract
if ($CourseState -notmatch '^lesson-\d{2}-(start|complete)$') {
    throw "Invalid CourseState. Must match ^lesson-\d{2}-(start|complete)$ (e.g. lesson-01-start or lesson-02-start)."
}

# Strict PackageProfile validation
$allowedProfiles = @("", "lesson-02-fallback-start")
if (-not [string]::IsNullOrWhiteSpace($PackageProfile) -and ($allowedProfiles -notcontains $PackageProfile)) {
    throw "Unknown or unsupported PackageProfile: '$PackageProfile'."
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

# Determine Package Base Name
if ($PackageProfile -eq "lesson-02-fallback-start") {
    if ($CourseState -ne "lesson-02-start") {
        throw "PackageProfile 'lesson-02-fallback-start' requires CourseState 'lesson-02-start'."
    }
    $packageBaseName = "ai-business-prototype-lesson-02-fallback-start-$Version"
} else {
    $packageBaseName = "ai-business-prototype-$CourseState-$Version"
}

# Runtime whitelist
$runtimeWhitelist = @(
    "package.json",
    "package-lock.json",
    "vite.config.ts",
    "tsconfig.json",
    "index.html",
    "start-project.bat",
    "DESIGN.md",
    "src",
    "docs/PROJECT_STATE.md",
    "docs/COMPONENT_CATALOG.md",
    "docs/LESSON_01_GUIDE.md",
    "docs/assets/lesson-01/lesson-flow.png"
)

if ($PackageProfile -eq "lesson-02-fallback-start") {
    $runtimeWhitelist += @(
        "docs/LESSON_02_GUIDE.md",
        "docs/assets/lesson-02/lesson-02-flow.png",
        "docs/assets/lesson-02/ref-monitor-decision.png",
        "docs/assets/lesson-02/ref-task-workflow.png",
        "docs/assets/lesson-02/ref-operation-tool.png"
    )
}

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

if ($PackageProfile -eq "lesson-02-fallback-start") {
    $fixtureExists = Test-GitPathExists -Commit $sourceCommit -GitPath "course-fixtures/lesson-02-fallback"
    if (-not $fixtureExists) {
        throw "Required fixture directory missing in SourceCommit: course-fixtures/lesson-02-fallback"
    }
    $archivePaths.Add("course-fixtures/lesson-02-fallback")
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

    # Overlay Merging for PackageProfile: lesson-02-fallback-start
    if ($PackageProfile -eq "lesson-02-fallback-start") {
        Write-Step "Merging Lesson 02 Fallback Fixtures Overlay with Strict Scope Verification"
        
        $fixtureSnap = Join-Path $snapshotDir "course-fixtures\lesson-02-fallback"
        $manifestPath = Join-Path $fixtureSnap "fixture-manifest.json"
        
        if (-not (Test-Path -LiteralPath $manifestPath)) {
            throw "Fixture manifest missing: course-fixtures/lesson-02-fallback/fixture-manifest.json"
        }

        $manifestRaw = [System.IO.File]::ReadAllText($manifestPath)
        $manifest = ConvertFrom-Json $manifestRaw

        # 1. Verify runtimeBaseCommit is ancestor or equals
        $runtimeBaseCommit = $manifest.runtimeBaseCommit
        & git merge-base --is-ancestor $runtimeBaseCommit $sourceCommit
        if ($LASTEXITCODE -ne 0) {
            throw "Manifest runtimeBaseCommit '$runtimeBaseCommit' is not an ancestor of SourceCommit '$sourceCommit'."
        }

        # 2. Strict Overlay Fileset Equivalence Assertion (Blocker Fix #2)
        $overlayDir = Join-Path $fixtureSnap "overlay"
        if (-not (Test-Path -LiteralPath $overlayDir)) {
            throw "Overlay directory missing: course-fixtures/lesson-02-fallback/overlay"
        }

        $actualOverlayFiles = Get-ChildItem -Path $overlayDir -Recurse -File | ForEach-Object {
            "overlay/" + $_.FullName.Substring($overlayDir.Length + 1).Replace("\", "/")
        } | Sort-Object

        $manifestSources = @($manifest.overlayFiles | ForEach-Object { $_.source }) | Sort-Object

        # Check duplicate sources or targets in manifest
        $manifestTargets = @($manifest.overlayFiles | ForEach-Object { $_.target }) | Sort-Object
        if (($manifestSources | Select-Object -Unique).Count -ne $manifestSources.Count) {
            throw "Duplicate source paths detected in fixture-manifest.json!"
        }
        if (($manifestTargets | Select-Object -Unique).Count -ne $manifestTargets.Count) {
            throw "Duplicate target paths detected in fixture-manifest.json!"
        }

        $actualOverlayStr = $actualOverlayFiles -join "`n"
        $manifestSourcesStr = $manifestSources -join "`n"

        if ($actualOverlayStr -ne $manifestSourcesStr) {
            throw "Overlay scope failure: Actual overlay disk files set does not equal fixture-manifest.json overlayFiles.source set!"
        }

        # 3. Precheck all overlayFiles operations using Normalized LF SHA256 Hash Comparison
        $appliedChanges = @()
        foreach ($ov in $manifest.overlayFiles) {
            $op = $ov.operation
            $ovSrc = Join-Path $fixtureSnap ($ov.source -replace '/', '\')
            $ovDst = Join-Path $packageRoot ($ov.target -replace '/', '\')

            if (-not (Test-Path -LiteralPath $ovSrc)) {
                throw "Overlay source file missing: $($ov.source)"
            }

            if ($op -eq "add") {
                if ($ov.expectedTargetAbsent -and (Test-Path -LiteralPath $ovDst)) {
                    throw "Overlay 'add' operation failed: Target file already exists at '$($ov.target)'."
                }
            }
            elseif ($op -eq "replace") {
                if (-not (Test-Path -LiteralPath $ovDst)) {
                    throw "Overlay 'replace' operation failed: Target file does not exist at '$($ov.target)'."
                }
                $dstHash = Get-NormalizedContentSha256Hex -Path $ovDst
                if ($ov.expectedBaseSha256 -and ($dstHash -ne $ov.expectedBaseSha256.ToLowerInvariant())) {
                    throw "Overlay 'replace' operation failed: Target file '$($ov.target)' normalized hash ($dstHash) does not match expectedBaseSha256 ($($ov.expectedBaseSha256))."
                }
            }
            else {
                throw "Unsupported overlay operation '$op' in fixture-manifest.json."
            }

            $appliedChanges += $ov.target
        }

        # 4. Apply overlay files to packageRoot
        foreach ($ov in $manifest.overlayFiles) {
            $ovSrc = Join-Path $fixtureSnap ($ov.source -replace '/', '\')
            $ovDst = Join-Path $packageRoot ($ov.target -replace '/', '\')
            $dstParent = Split-Path -Parent $ovDst
            if (-not (Test-Path -LiteralPath $dstParent)) {
                New-Item -ItemType Directory -Path $dstParent -Force | Out-Null
            }
            Copy-Item -LiteralPath $ovSrc -Destination $ovDst -Force
            Write-Host " Applied Overlay [$($ov.operation)]: $($ov.target)"
        }
        
        Write-Host "[PASS] All $( $appliedChanges.Length ) Overlay operations applied cleanly."
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
        "Package Profile: $PackageProfile",
        "Version: $Version",
        "Source Ref: $SourceRef",
        "Source Commit: $sourceCommit",
        "Built At UTC: $builtAtUtc",
        "Git Required: No",
        "Delivery Mode: ZIP learner package"
    )
    [System.IO.File]::WriteAllLines((Join-Path $packageRoot "VERSION.txt"), $versionLines, $utf8NoBom)

    Write-Step "Building PACKAGE_MANIFEST.txt and SHA256SUMS.txt (Closed-Set Contract)"
    # Collect all existing files in packageRoot
    $existingPkgFiles = Get-ChildItem -LiteralPath $packageRoot -Recurse -File | Sort-Object FullName
    $manifestLines = New-Object System.Collections.Generic.List[string]

    foreach ($file in $existingPkgFiles) {
        $rel = Get-RelativePathUnix -BasePath $packageRoot -FullPath $file.FullName
        $manifestLines.Add($rel)
    }
    # Manifest contains PACKAGE_MANIFEST.txt and SHA256SUMS.txt
    $manifestLines.Add("PACKAGE_MANIFEST.txt")
    $manifestLines.Add("SHA256SUMS.txt")
    $sortedManifestLines = $manifestLines | Sort-Object

    [System.IO.File]::WriteAllLines((Join-Path $packageRoot "PACKAGE_MANIFEST.txt"), $sortedManifestLines, $utf8NoBom)

    # SHA256SUMS contains hashes for all files in PACKAGE_MANIFEST except SHA256SUMS.txt itself
    $filesForSha = Get-ChildItem -LiteralPath $packageRoot -Recurse -File | Where-Object { $_.Name -ne "SHA256SUMS.txt" } | Sort-Object FullName
    $sumLines = New-Object System.Collections.Generic.List[string]

    foreach ($file in $filesForSha) {
        $rel = Get-RelativePathUnix -BasePath $packageRoot -FullPath $file.FullName
        $hash = Get-FileSha256Hex -Path $file.FullName
        $sumLines.Add("$hash  $rel")
    }

    [System.IO.File]::WriteAllLines((Join-Path $packageRoot "SHA256SUMS.txt"), $sumLines, $utf8NoBom)

    # Assert exact closed-set equivalence
    $actualPackageDiskFiles = Get-ChildItem -LiteralPath $packageRoot -Recurse -File | ForEach-Object {
        Get-RelativePathUnix -BasePath $packageRoot -FullPath $_.FullName
    } | Sort-Object

    $declaredPackageManifestFiles = Get-Content -Path (Join-Path $packageRoot "PACKAGE_MANIFEST.txt") | Sort-Object

    if (($actualPackageDiskFiles -join "`n") -ne ($declaredPackageManifestFiles -join "`n")) {
        throw "Student package export assertion failed: Disk files set does not equal PACKAGE_MANIFEST.txt!"
    }

    Write-Step "Safety check (after metadata)"
    Invoke-PackageSafetyCheck -PackageRoot $packageRoot -Phase "post-metadata"

    Write-Step "Sensitive content scan"
    Invoke-SensitiveContentScan -PackageRoot $packageRoot

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
        if (Test-Path -LiteralPath $zipPath) {
            Remove-Item -LiteralPath $zipPath -Force -ErrorAction SilentlyContinue
        }
        if (Test-Path -LiteralPath $zipShaPath) {
            Remove-Item -LiteralPath $zipShaPath -Force -ErrorAction SilentlyContinue
        }
    }
    if (Test-Path -LiteralPath $stagingRoot) {
        Remove-Item -LiteralPath $stagingRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
