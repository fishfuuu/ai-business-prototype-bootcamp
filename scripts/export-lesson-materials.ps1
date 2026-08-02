<#
.SYNOPSIS
    Export Lesson 02 Materials Package with payload/metadata separation.
.DESCRIPTION
    Exports a zip package containing payload/docs/** and metadata/**, with install-lesson-materials.ps1.
#>

[CmdletBinding()]
param(
    [string]$Version = "v0.1.0",
    [string]$SourceRef = "HEAD",
    [string]$OutputDirectory = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = (Get-Item $PSScriptRoot).Parent.FullName

if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = Join-Path $repoRoot "artifacts/student-packages"
}

if (-not (Test-Path -LiteralPath $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

$packageName = "ai-business-prototype-lesson-02-materials-$Version"
$tempDir = Join-Path $env:TEMP ("export-l2-materials-" + [Guid]::NewGuid().ToString("N"))
$stageDir = Join-Path $tempDir $packageName

Write-Host "========================================"
Write-Host "Export Lesson 02 Materials Package"
Write-Host "========================================"
Write-Host "Package:     $packageName"
Write-Host "Version:     $Version"
Write-Host "SourceRef:   $SourceRef"

# Create directories
New-Item -ItemType Directory -Path (Join-Path $stageDir "payload/docs/assets/lesson-02") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $stageDir "metadata") -Force | Out-Null

# Copy Payload Files from HEAD
$payloadFiles = @(
    "docs/LESSON_02_GUIDE.md",
    "docs/assets/lesson-02/lesson-02-flow.png",
    "docs/assets/lesson-02/ref-dashboard.png",
    "docs/assets/lesson-02/ref-table-list.png",
    "docs/assets/lesson-02/ref-form-detail.png"
)

foreach ($pf in $payloadFiles) {
    $src = Join-Path $repoRoot $pf
    if (-not (Test-Path -LiteralPath $src)) {
        throw "Payload file missing in repository: $pf"
    }
    $destRel = $pf.Replace('/', '\')
    $dest = Join-Path (Join-Path $stageDir "payload") $destRel
    $destParent = Split-Path -Parent $dest
    if (-not (Test-Path -LiteralPath $destParent)) {
        New-Item -ItemType Directory -Path $destParent -Force | Out-Null
    }
    Copy-Item -LiteralPath $src -Destination $dest -Force
}

# Copy Installer Script
$installerSrc = Join-Path $repoRoot "scripts/install-lesson-materials.ps1"
if (-not (Test-Path -LiteralPath $installerSrc)) {
    throw "Installer script missing: scripts/install-lesson-materials.ps1"
}
Copy-Item -LiteralPath $installerSrc -Destination (Join-Path $stageDir "install-lesson-materials.ps1") -Force

# Write Metadata
Set-Content -Path (Join-Path $stageDir "metadata/VERSION.txt") -Value "Package: $packageName`nVersion: $Version`nSourceRef: $SourceRef" -Encoding UTF8

# Build Manifest & SHA256SUMS
$manifestPath = Join-Path $stageDir "metadata/PACKAGE_MANIFEST.txt"
$shaSumsPath = Join-Path $stageDir "metadata/SHA256SUMS.txt"

$allFiles = Get-ChildItem -LiteralPath $stageDir -Recurse -File
$manifestLines = @()
$shaLines = @()

foreach ($file in $allFiles) {
    $rel = $file.FullName.Substring($stageDir.Length + 1).Replace('\', '/')
    $hash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
    $manifestLines += "$rel $($file.Length)"
    $shaLines += "$hash  $rel"
}

Set-Content -Path $manifestPath -Value ($manifestLines -join "`n") -Encoding UTF8
Set-Content -Path $shaSumsPath -Value ($shaLines -join "`n") -Encoding UTF8

# Create ZIP
$zipPath = Join-Path $OutputDirectory "$packageName.zip"
if (Test-Path -LiteralPath $zipPath) {
    Remove-Item -LiteralPath $zipPath -Force
}

Compress-Archive -Path $stageDir -DestinationPath $zipPath -Force

# Calculate ZIP SHA256
$zipHash = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash
Set-Content -Path "$zipPath.sha256" -Value "$zipHash  $packageName.zip" -Encoding UTF8

# Clean temp
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "========================================"
Write-Host "Materials Package Export completed"
Write-Host "ZIP: $zipPath"
Write-Host "ZIP SHA256: $zipHash"
Write-Host "========================================"
