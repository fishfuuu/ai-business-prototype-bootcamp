param(
    [string]$TargetStudentProjectDir = "."
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$scriptRoot = $PSScriptRoot
$targetDir = (Resolve-Path $TargetStudentProjectDir).Path

Write-Host "========================================"
Write-Host "Lesson 02 Materials Safe Installer"
Write-Host "========================================"
Write-Host "Target Project: $targetDir"
Write-Host ""

# 1. Target project validity precheck
$requiredTargetFiles = @(
    "package.json",
    "DESIGN.md",
    "docs\LESSON_01_GUIDE.md"
)

foreach ($req in $requiredTargetFiles) {
    $fullPath = Join-Path $targetDir $req
    if (-not (Test-Path $fullPath)) {
        throw "Target project is invalid or missing required file: $req"
    }
}
Write-Host "[PASS] Target project validity check passed."

# 2. Locate package payload and metadata directories
$packageRoot = (Get-Item $scriptRoot).FullName
$payloadDocsDir = Join-Path $packageRoot "payload\docs"
$metadataDir = Join-Path $packageRoot "metadata"

if (-not (Test-Path $payloadDocsDir)) {
    throw "Package is corrupted: payload/docs directory is missing."
}
if (-not (Test-Path $metadataDir)) {
    throw "Package is corrupted: metadata directory is missing."
}

# 3. Closed-Set Package Integrity Assertion
$manifestFile = Join-Path $metadataDir "PACKAGE_MANIFEST.txt"
$checksumsFile = Join-Path $metadataDir "SHA256SUMS.txt"

if (-not (Test-Path $manifestFile)) {
    throw "Package manifest file is missing: metadata/PACKAGE_MANIFEST.txt"
}
if (-not (Test-Path $checksumsFile)) {
    throw "Package checksums file is missing: metadata/SHA256SUMS.txt"
}

# Assert Actual Package Files Set == PACKAGE_MANIFEST.txt
$actualPackageFiles = Get-ChildItem -Path $packageRoot -Recurse -File | ForEach-Object {
    $_.FullName.Substring($packageRoot.Length + 1).Replace("\", "/")
} | Sort-Object

$declaredManifestFiles = Get-Content -Path $manifestFile | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object

$actualStr = $actualPackageFiles -join "`n"
$declaredStr = $declaredManifestFiles -join "`n"

if ($actualStr -ne $declaredStr) {
    throw "Package integrity failure: Actual package files set does not equal metadata/PACKAGE_MANIFEST.txt!"
}

# Verify every file listed in SHA256SUMS.txt against its actual hash
$checksumLines = Get-Content -Path $checksumsFile | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
$checksumFilesDeclared = New-Object System.Collections.Generic.List[string]

foreach ($line in $checksumLines) {
    $parts = $line -split '\s+', 2
    if ($parts.Length -ne 2) {
        throw "Invalid checksum line format in metadata/SHA256SUMS.txt: $line"
    }
    $expectedHash = $parts[0].Trim().ToLowerInvariant()
    $relPath = $parts[1].Trim().Replace('/', '\')
    $relUnix = $parts[1].Trim().Replace('\', '/')
    
    $checksumFilesDeclared.Add($relUnix)

    $localFilePath = Join-Path $packageRoot $relPath
    if (-not (Test-Path $localFilePath)) {
        throw "Package verification failed: File declared in SHA256SUMS.txt is missing: $relPath"
    }
    
    $actualHash = (Get-FileHash -Path $localFilePath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actualHash -ne $expectedHash) {
        throw "Package integrity failure! Checksum mismatch on '$relPath'. Expected: $expectedHash, Actual: $actualHash"
    }
}

# Assert SHA256SUMS Set == PACKAGE_MANIFEST Set - SHA256SUMS.txt
$expectedSumSet = $declaredManifestFiles | Where-Object { $_ -ne "metadata/SHA256SUMS.txt" } | Sort-Object
$actualSumSet = $checksumFilesDeclared | Sort-Object

if (($expectedSumSet -join "`n") -ne ($actualSumSet -join "`n")) {
    throw "Package integrity failure: metadata/SHA256SUMS.txt declaration set does not equal (PACKAGE_MANIFEST.txt - SHA256SUMS.txt)!"
}

Write-Host "[PASS] Package integrity verified. Closed-set manifest & SHA256SUMS match 100%."

# 4. Precheck target files and conflicts (No Clobber Rule)
$payloadDocsDirNormalized = [System.IO.Path]::GetFullPath($payloadDocsDir).TrimEnd('\')
$payloadFiles = Get-ChildItem -Path $payloadDocsDirNormalized -Recurse -File | Sort-Object { $_.FullName }
$copyPlan = @() # Elements: @{ SourcePath, TargetPath, RelPath, Status ('NEW', 'SKIP') }

foreach ($file in $payloadFiles) {
    $normFullName = [System.IO.Path]::GetFullPath($file.FullName)
    $relPath = $normFullName.Substring($payloadDocsDirNormalized.Length + 1)
    $targetPath = Join-Path $targetDir ("docs\" + $relPath)
    
    $sourceHash = (Get-FileHash -Path $normFullName -Algorithm SHA256).Hash.ToLowerInvariant()
    
    if (Test-Path $targetPath) {
        $targetHash = (Get-FileHash -Path $targetPath -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($sourceHash -eq $targetHash) {
            $copyPlan += @{
                SourcePath = $normFullName
                TargetPath = $targetPath
                RelPath = $relPath
                Status = "SKIP"
            }
        } else {
            throw "Conflict detected on '$relPath'. Existing target file content differs from payload. Installation aborted before any file modifications."
        }
    } else {
        $copyPlan += @{
            SourcePath = $normFullName
            TargetPath = $targetPath
            RelPath = $relPath
            Status = "NEW"
        }
    }
}
Write-Host "[PASS] All target file prechecks passed. Conflict check 100% clean."

# Helper function: Record src/** exact file relative path + SHA256 manifest
function Get-SrcManifest($projectDir) {
    $srcDir = Join-Path $projectDir "src"
    if (-not (Test-Path $srcDir)) {
        return @()
    }
    $files = Get-ChildItem -Path $srcDir -Recurse -File | Sort-Object { $_.FullName }
    $manifest = @()
    foreach ($f in $files) {
        $rel = $f.FullName.Substring($srcDir.Length + 1).Replace("\", "/")
        $hash = (Get-FileHash -Path $f.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        $manifest += "$rel::$hash"
    }
    return $manifest
}

# 5. Record src/** manifest before installation
$srcManifestBefore = Get-SrcManifest $targetDir

# 6. Execute atomic copy
$newCreatedFiles = @()
try {
    foreach ($item in $copyPlan) {
        if ($item.Status -eq "NEW") {
            $parentDir = Split-Path -Parent $item.TargetPath
            if (-not (Test-Path $parentDir)) {
                New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
            }
            Copy-Item -Path $item.SourcePath -Destination $item.TargetPath -Force
            $newCreatedFiles += $item.TargetPath
            Write-Host " Installed: docs\$($item.RelPath)"
        } else {
            Write-Host " Skipped (Unchanged): docs\$($item.RelPath)"
        }
    }
}
catch {
    Write-Host "Installation failed mid-way. Cleaning up newly created files..." -ForegroundColor Red
    foreach ($created in $newCreatedFiles) {
        if (Test-Path $created) {
            Remove-Item -Path $created -Force -ErrorAction SilentlyContinue
        }
    }
    throw $_
}

# 7. Record src/** manifest after installation and assert 100% zero modification
$srcManifestAfter = Get-SrcManifest $targetDir

$beforeStr = $srcManifestBefore -join "`n"
$afterStr = $srcManifestAfter -join "`n"

if ($beforeStr -ne $afterStr) {
    # Rollback
    foreach ($created in $newCreatedFiles) {
        if (Test-Path $created) {
            Remove-Item -Path $created -Force -ErrorAction SilentlyContinue
        }
    }
    throw "CRITICAL FAILURE: src/** directory was modified during materials installation! Rollback executed."
}
Write-Host "[PASS] Assert src/** exact manifest 100% unchanged."

# 8. Write success receipt to local-backups/lesson-02-evidence/
$evidenceDir = Join-Path $targetDir "local-backups\lesson-02-evidence"
if (-not (Test-Path $evidenceDir)) {
    New-Item -ItemType Directory -Path $evidenceDir -Force | Out-Null
}

$receiptPath = Join-Path $evidenceDir "materials-install-receipt.json"
$installedAtUtc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

$installedRelFiles = @($copyPlan | Where-Object { $_.Status -eq "NEW" } | ForEach-Object { $_.RelPath })
$skippedRelFiles = @($copyPlan | Where-Object { $_.Status -eq "SKIP" } | ForEach-Object { $_.RelPath })

$receiptObj = [ordered]@{
    status = "SUCCESS"
    installedAtUtc = $installedAtUtc
    installedFiles = $installedRelFiles
    skippedFiles = $skippedRelFiles
    srcManifestMatch = $true
}

$receiptJson = ConvertTo-Json $receiptObj -Depth 5
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($receiptPath, $receiptJson, $utf8NoBom)

Write-Host "========================================"
Write-Host "Installation Completed Successfully!"
Write-Host "Receipt Saved: local-backups/lesson-02-evidence/materials-install-receipt.json"
Write-Host "========================================"
