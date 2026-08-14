param(
    [string]$Version = "v0.1.0",
    [string]$SourceRef = "HEAD",
    [string]$OutputDir = "artifacts/student-packages"
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

Write-Host "========================================"
Write-Host "Exporting Lesson Materials Package"
Write-Host "========================================"
Write-Host "SourceRef: $SourceRef"
Write-Host "Version:   $Version"
Write-Host "OutputDir: $OutputDir"
Write-Host ""

# 1. Resolve git commit SHA for SourceRef
$sourceCommit = (git rev-parse --verify "$SourceRef^{commit}" 2>$null)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($sourceCommit)) {
    throw "Failed to resolve git commit SHA for SourceRef '$SourceRef'."
}
$sourceCommit = $sourceCommit.Trim()
Write-Host "Resolved Source Commit: $sourceCommit"

# 2. Check output target ZIP path and SHA256 file
if ([System.IO.Path]::IsPathRooted($OutputDir)) {
    $artifactDir = [System.IO.Path]::GetFullPath($OutputDir)
} else {
    $artifactDir = Join-Path $projectRoot $OutputDir
}

if (-not (Test-Path $artifactDir)) {
    New-Item -ItemType Directory -Path $artifactDir -Force | Out-Null
}

$zipName = "ai-business-prototype-lesson-02-materials-$Version.zip"
$targetZipPath = Join-Path $artifactDir $zipName
$targetShaPath = Join-Path $artifactDir "$zipName.sha256"

if (Test-Path $targetZipPath) {
    throw "Target ZIP package already exists: $targetZipPath. Overwrite is forbidden."
}
if (Test-Path $targetShaPath) {
    throw "Target SHA256 file already exists: $targetShaPath. Overwrite is forbidden."
}

# 3. Create temp staging directory
$tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("l2-materials-export-" + [Guid]::NewGuid().ToString("N"))
$packageStaging = Join-Path $tempDir "package"
$metadataDir = Join-Path $packageStaging "metadata"
$payloadDocsDir = Join-Path $packageStaging "payload\docs"

New-Item -ItemType Directory -Path $metadataDir -Force | Out-Null
New-Item -ItemType Directory -Path $payloadDocsDir -Force | Out-Null

$exportSucceeded = $false
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

try {
    # 4. Extract install-lesson-materials.ps1 ONLY from SourceCommit via git show
    $installerPath = Join-Path $packageStaging "install-lesson-materials.ps1"
    $installerContent = & git show "$sourceCommit`:scripts/install-lesson-materials.ps1" 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($installerContent)) {
        throw "Failed to extract scripts/install-lesson-materials.ps1 from SourceCommit $sourceCommit."
    }
    [System.IO.File]::WriteAllLines($installerPath, $installerContent, $utf8NoBom)

    # 5. Extract payload/ files from SourceCommit via git archive
    $gitArchiveZip = Join-Path $tempDir "git-archive.zip"
    & git archive --format=zip -o $gitArchiveZip $sourceCommit lessons .claude/skills .claude/agents scripts
    if ($LASTEXITCODE -ne 0) {
        throw "git archive for lessons, skills, agents & scripts failed on SourceCommit $sourceCommit."
    }

    $archiveExtractDir = Join-Path $tempDir "git-archive-extracted"
    Expand-Archive -Path $gitArchiveZip -DestinationPath $archiveExtractDir -Force

    $payloadStagingDir = Join-Path $packageStaging "payload"
    New-Item -ItemType Directory -Path $payloadStagingDir -Force | Out-Null
    Copy-Item -Path "$archiveExtractDir\*" -Destination $payloadStagingDir -Recurse -Force

    # Filter to only keep allowed lesson relevant files in payload
    $allowedRelativePaths = @(
        "lessons\LESSON_02_GUIDE.md",
        ".claude\skills\grill-me\SKILL.md",
        "lessons\LESSON_03_GUIDE.md",
        ".claude\skills\incremental-implementation\SKILL.md",
        ".claude\agents\qa-tester.md",
        "scripts\install-lesson-materials.ps1"
    )

    $allExtractedFiles = Get-ChildItem -Path $payloadStagingDir -Recurse -File
    foreach ($file in $allExtractedFiles) {
        $relPath = $file.FullName.Substring($payloadStagingDir.Length + 1)
        if ($allowedRelativePaths -notcontains $relPath) {
            Remove-Item -Path $file.FullName -Force
        }
    }

    # 6. Generate VERSION.txt
    $builtAtUtc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $versionLines = @(
        "Package: ai-business-prototype-lesson-02-materials",
        "Version: $Version",
        "Repository Source Commit: $sourceCommit",
        "Built At UTC: $builtAtUtc",
        "Delivery Mode: Incremental Materials Overlay"
    )
    [System.IO.File]::WriteAllLines((Join-Path $metadataDir "VERSION.txt"), $versionLines, $utf8NoBom)

    # 7. Generate PACKAGE_MANIFEST.txt & SHA256SUMS.txt (Exact Closed-Set Contract)
    $existingFiles = Get-ChildItem -Path $packageStaging -Recurse -File | Sort-Object { $_.FullName }
    $manifestLines = New-Object System.Collections.Generic.List[string]

    foreach ($file in $existingFiles) {
        $relPath = $file.FullName.Substring($packageStaging.Length + 1).Replace("\", "/")
        $manifestLines.Add($relPath)
    }
    # PACKAGE_MANIFEST.txt includes PACKAGE_MANIFEST.txt itself AND SHA256SUMS.txt
    $manifestLines.Add("metadata/PACKAGE_MANIFEST.txt")
    $manifestLines.Add("metadata/SHA256SUMS.txt")
    $sortedManifestLines = $manifestLines | Sort-Object

    [System.IO.File]::WriteAllLines((Join-Path $metadataDir "PACKAGE_MANIFEST.txt"), $sortedManifestLines, $utf8NoBom)

    # Compute SHA256 for all files in PACKAGE_MANIFEST.txt except SHA256SUMS.txt itself
    $sumLines = New-Object System.Collections.Generic.List[string]
    $filesForSha = Get-ChildItem -Path $packageStaging -Recurse -File | Where-Object { $_.Name -ne "SHA256SUMS.txt" } | Sort-Object { $_.FullName }

    foreach ($file in $filesForSha) {
        $relPath = $file.FullName.Substring($packageStaging.Length + 1).Replace("\", "/")
        $hash = (Get-FileHash -Path $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        $sumLines.Add("$hash  $relPath")
    }

    [System.IO.File]::WriteAllLines((Join-Path $metadataDir "SHA256SUMS.txt"), $sumLines, $utf8NoBom)

    # 8. Assert exact closed-set equivalence: Actual Staging files == PACKAGE_MANIFEST.txt
    $actualStagingFiles = Get-ChildItem -Path $packageStaging -Recurse -File | ForEach-Object {
        $_.FullName.Substring($packageStaging.Length + 1).Replace("\", "/")
    } | Sort-Object

    $declaredManifestFiles = Get-Content -Path (Join-Path $metadataDir "PACKAGE_MANIFEST.txt") | Sort-Object

    $actualStr = $actualStagingFiles -join "`n"
    $declaredStr = $declaredManifestFiles -join "`n"

    if ($actualStr -ne $declaredStr) {
        throw "Materials package export assertion failed: Actual staging files set does not equal PACKAGE_MANIFEST.txt."
    }

    # 9. Create ZIP archive
    Compress-Archive -Path "$packageStaging\*" -DestinationPath $targetZipPath -CompressionLevel Optimal

    # 10. Create external ZIP SHA256 checksum file
    $zipHash = (Get-FileHash -Path $targetZipPath -Algorithm SHA256).Hash.ToLowerInvariant()
    [System.IO.File]::WriteAllText($targetShaPath, "$zipHash  $zipName`n", $utf8NoBom)

    $exportSucceeded = $true

    Write-Host "========================================"
    Write-Host "Export Successful!"
    Write-Host "Package Path: $targetZipPath"
    Write-Host "SHA256 Path:  $targetShaPath ($zipHash)"
    Write-Host "Package Size: $((Get-Item $targetZipPath).Length) bytes"
    Write-Host "========================================"
}
finally {
    if (-not $exportSucceeded) {
        if (Test-Path $targetZipPath) { Remove-Item -Path $targetZipPath -Force -ErrorAction SilentlyContinue }
        if (Test-Path $targetShaPath) { Remove-Item -Path $targetShaPath -Force -ErrorAction SilentlyContinue }
    }
    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}