param(
    [string]$Version = "v0.1.0",
    [string]$SourceRef = "HEAD",
    [string]$OutputDir = "artifacts/student-packages"
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

Write-Host "========================================"
Write-Host "Exporting Lesson 02 Materials Package"
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
    # 4. Extract install-lesson-materials.ps1 ONLY from SourceCommit via git show (No working tree fallback)
    $installerPath = Join-Path $packageStaging "install-lesson-materials.ps1"
    $installerContent = & git show "$sourceCommit`:scripts/install-lesson-materials.ps1" 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($installerContent)) {
        throw "Failed to extract scripts/install-lesson-materials.ps1 from SourceCommit $sourceCommit."
    }
    [System.IO.File]::WriteAllLines($installerPath, $installerContent, $utf8NoBom)

    # 5. Extract payload/docs/ files from SourceCommit via git archive
    $gitArchiveZip = Join-Path $tempDir "git-archive.zip"
    & git archive --format=zip -o $gitArchiveZip $sourceCommit docs
    if ($LASTEXITCODE -ne 0) {
        throw "git archive for docs failed on SourceCommit $sourceCommit."
    }
    
    $archiveExtractDir = Join-Path $tempDir "git-archive-extracted"
    Expand-Archive -Path $gitArchiveZip -DestinationPath $archiveExtractDir -Force
    
    $extractedDocs = Join-Path $archiveExtractDir "docs"
    if (-not (Test-Path $extractedDocs)) {
        throw "Extracted git archive does not contain docs/ directory."
    }
    Copy-Item -Path "$extractedDocs\*" -Destination $payloadDocsDir -Recurse -Force

    # Filter to only keep second-lesson relevant docs in payload
    $allowedRelativePaths = @(
        "LESSON_02_GUIDE.md",
        "assets\lesson-02\lesson-02-flow.png",
        "assets\lesson-02\ref-monitor-decision.png",
        "assets\lesson-02\ref-task-workflow.png",
        "assets\lesson-02\ref-operation-tool.png"
    )

    $allExtractedFiles = Get-ChildItem -Path $payloadDocsDir -Recurse -File
    foreach ($file in $allExtractedFiles) {
        $relPath = $file.FullName.Substring($payloadDocsDir.Length + 1)
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

    # 7. Generate PACKAGE_MANIFEST.txt & SHA256SUMS.txt (Deterministic contract)
    # Step A: Collect all files except SHA256SUMS.txt
    $payloadFiles = Get-ChildItem -Path $packageStaging -Recurse -File | Sort-Object { $_.FullName }
    $manifestLines = New-Object System.Collections.Generic.List[string]

    foreach ($file in $payloadFiles) {
        $relPath = $file.FullName.Substring($packageStaging.Length + 1).Replace("\", "/")
        $manifestLines.Add($relPath)
    }
    # Manifest includes PACKAGE_MANIFEST.txt itself
    $manifestLines.Add("metadata/PACKAGE_MANIFEST.txt")
    $sortedManifestLines = $manifestLines | Sort-Object

    [System.IO.File]::WriteAllLines((Join-Path $metadataDir "PACKAGE_MANIFEST.txt"), $sortedManifestLines, $utf8NoBom)

    # Step B: Compute SHA256 for all files including PACKAGE_MANIFEST.txt, excluding only SHA256SUMS.txt
    $finalFilesForSum = Get-ChildItem -Path $packageStaging -Recurse -File | Where-Object { $_.Name -ne "SHA256SUMS.txt" } | Sort-Object { $_.FullName }
    $sumLines = New-Object System.Collections.Generic.List[string]

    foreach ($file in $finalFilesForSum) {
        $relPath = $file.FullName.Substring($packageStaging.Length + 1).Replace("\", "/")
        $hash = (Get-FileHash -Path $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        $sumLines.Add("$hash  $relPath")
    }

    [System.IO.File]::WriteAllLines((Join-Path $metadataDir "SHA256SUMS.txt"), $sumLines, $utf8NoBom)

    # 8. Create ZIP archive
    Compress-Archive -Path "$packageStaging\*" -DestinationPath $targetZipPath -CompressionLevel Optimal

    # 9. Create external ZIP SHA256 checksum file
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
