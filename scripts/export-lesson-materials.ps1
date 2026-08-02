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
$sourceCommit = (git rev-parse $SourceRef).Trim()
if (-not $sourceCommit) {
    throw "Failed to resolve git commit SHA for SourceRef '$SourceRef'."
}
Write-Host "Resolved Source Commit: $sourceCommit"

# 2. Check output target ZIP path
$artifactDir = Join-Path $projectRoot $OutputDir
if (-not (Test-Path $artifactDir)) {
    New-Item -ItemType Directory -Path $artifactDir -Force | Out-Null
}

$zipName = "ai-business-prototype-lesson-02-materials-$Version.zip"
$targetZipPath = Join-Path $artifactDir $zipName

if (Test-Path $targetZipPath) {
    throw "Target ZIP package already exists: $targetZipPath. Overwrite is forbidden."
}

# 3. Create temp staging directory
$tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("l2-materials-export-" + [Guid]::NewGuid().ToString("N"))
$packageStaging = Join-Path $tempDir "package"
$metadataDir = Join-Path $packageStaging "metadata"
$payloadDocsDir = Join-Path $packageStaging "payload\docs"

New-Item -ItemType Directory -Path $metadataDir -Force | Out-Null
New-Item -ItemType Directory -Path $payloadDocsDir -Force | Out-Null

try {
    # 4. Extract install-lesson-materials.ps1 from SourceRef or working tree if matching HEAD
    $installerPath = Join-Path $packageStaging "install-lesson-materials.ps1"
    $workingInstaller = Join-Path $projectRoot "scripts\install-lesson-materials.ps1"
    
    if (Test-Path $workingInstaller) {
        Copy-Item -Path $workingInstaller -Destination $installerPath -Force
    } else {
        $installerContent = git show "$sourceCommit`:scripts/install-lesson-materials.ps1"
        if (-not $installerContent) {
            throw "Failed to extract scripts/install-lesson-materials.ps1 from commit $sourceCommit."
        }
        [System.IO.File]::WriteAllText($installerPath, ($installerContent -join "`n"), [System.Text.Encoding]::UTF8)
    }

    # 5. Extract payload/docs/ files from SourceRef
    $gitArchiveZip = Join-Path $tempDir "git-archive.zip"
    git archive --format=zip -o $gitArchiveZip $sourceCommit docs
    
    $archiveExtractDir = Join-Path $tempDir "git-archive-extracted"
    Expand-Archive -Path $gitArchiveZip -DestinationPath $archiveExtractDir -Force
    
    # Copy extracted docs/ to payload/docs/
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
    $versionContent = @"
Package: ai-business-prototype-lesson-02-materials
Version: $Version
Repository Source Commit: $sourceCommit
Built At UTC: $builtAtUtc
Delivery Mode: Incremental Materials Overlay
"@
    [System.IO.File]::WriteAllText((Join-Path $metadataDir "VERSION.txt"), $versionContent, [System.Text.Encoding]::UTF8)

    # 7. Generate PACKAGE_MANIFEST.txt & SHA256SUMS.txt
    $payloadFiles = Get-ChildItem -Path $packageStaging -Recurse -File | Sort-Object { $_.FullName }
    $manifestLines = @()
    $sha256Lines = @()

    foreach ($file in $payloadFiles) {
        $relPath = $file.FullName.Substring($packageStaging.Length + 1).Replace("\", "/")
        $hash = (Get-FileHash -Path $file.FullName -Algorithm SHA256).Hash.ToLower()
        
        $manifestLines += $relPath
        $sha256Lines += "$hash  $relPath"
    }

    [System.IO.File]::WriteAllText((Join-Path $metadataDir "PACKAGE_MANIFEST.txt"), ($manifestLines -join "`n"), [System.Text.Encoding]::UTF8)
    [System.IO.File]::WriteAllText((Join-Path $metadataDir "SHA256SUMS.txt"), ($sha256Lines -join "`n"), [System.Text.Encoding]::UTF8)

    # Re-build manifest and checksums to include metadata files sorted
    $finalFiles = Get-ChildItem -Path $packageStaging -Recurse -File | Sort-Object { $_.FullName }
    $finalManifestLines = @()
    $finalSha256Lines = @()

    foreach ($file in $finalFiles) {
        $relPath = $file.FullName.Substring($packageStaging.Length + 1).Replace("\", "/")
        $hash = (Get-FileHash -Path $file.FullName -Algorithm SHA256).Hash.ToLower()
        
        $finalManifestLines += $relPath
        $finalSha256Lines += "$hash  $relPath"
    }

    [System.IO.File]::WriteAllText((Join-Path $metadataDir "PACKAGE_MANIFEST.txt"), ($finalManifestLines -join "`n"), [System.Text.Encoding]::UTF8)
    [System.IO.File]::WriteAllText((Join-Path $metadataDir "SHA256SUMS.txt"), ($finalSha256Lines -join "`n"), [System.Text.Encoding]::UTF8)

    # 8. Create ZIP archive
    Compress-Archive -Path "$packageStaging\*" -DestinationPath $targetZipPath -CompressionLevel Optimal
    
    Write-Host "========================================"
    Write-Host "Export Successful!"
    Write-Host "Package Path: $targetZipPath"
    Write-Host "Package Size: $((Get-Item $targetZipPath).Length) bytes"
    Write-Host "========================================"
}
finally {
    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
