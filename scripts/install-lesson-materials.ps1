<#
.SYNOPSIS
    Installer script for Lesson 02 Materials Package.
.DESCRIPTION
    Safely injects payload/docs/** into student's Lesson 01 project directory.
    Validates src/** SHA256 before and after installation to guarantee 0 src modifications.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$TargetStudentProjectDir
)

$ErrorActionPreference = "Stop"
$scriptDir = (Get-Item $PSScriptRoot).FullName
$payloadDocs = Join-Path $scriptDir "payload/docs"

Write-Host "========================================"
Write-Host "Lesson 02 Materials Package Installer"
Write-Host "========================================"
Write-Host "Target Project: $TargetStudentProjectDir"

if (-not (Test-Path -LiteralPath $TargetStudentProjectDir)) {
    throw "Target student project directory does not exist: $TargetStudentProjectDir"
}

# 1. Validate Target Student Project Required Files
$req1 = Join-Path $TargetStudentProjectDir "package.json"
$req2 = Join-Path $TargetStudentProjectDir "DESIGN.md"
$req3 = Join-Path $TargetStudentProjectDir "docs/LESSON_01_GUIDE.md"

if (-not (Test-Path -LiteralPath $req1) -or -not (Test-Path -LiteralPath $req2) -or -not (Test-Path -LiteralPath $req3)) {
    throw "Target directory is not a valid Lesson 01 student project! Missing package.json, DESIGN.md, or docs/LESSON_01_GUIDE.md"
}

# 2. Compute src/** SHA256 Before Copy
$srcDir = Join-Path $TargetStudentProjectDir "src"
function Get-DirSrcHashes([string]$dir) {
    if (-not (Test-Path -LiteralPath $dir)) { return @() }
    $files = Get-ChildItem -LiteralPath $dir -Recurse -File | Sort-Object FullName
    $list = @()
    foreach ($f in $files) {
        $h = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash
        $rel = $f.FullName.Substring($dir.Length + 1).Replace('\', '/')
        $list += "$($rel):$($h)"
    }
    return ($list -join "|")
}

$srcHashBefore = Get-DirSrcHashes -dir $srcDir

# 3. Copy payload/docs/** to Target Student Project
if (-not (Test-Path -LiteralPath $payloadDocs)) {
    throw "Payload docs directory missing in package: $payloadDocs"
}

$targetDocs = Join-Path $TargetStudentProjectDir "docs"
if (-not (Test-Path -LiteralPath $targetDocs)) {
    New-Item -ItemType Directory -Path $targetDocs -Force | Out-Null
}

$payloadFiles = Get-ChildItem -LiteralPath $payloadDocs -Recurse -File
foreach ($pf in $payloadFiles) {
    $rel = $pf.FullName.Substring($payloadDocs.Length + 1)
    $dest = Join-Path $targetDocs $rel
    $destDir = Split-Path -Parent $dest

    if (-not (Test-Path -LiteralPath $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    # Anti-overwrite check: if same content exists, skip; if different, throw error
    if (Test-Path -LiteralPath $dest) {
        $hashPf = (Get-FileHash -LiteralPath $pf.FullName -Algorithm SHA256).Hash
        $hashDest = (Get-FileHash -LiteralPath $dest -Algorithm SHA256).Hash
        if ($hashPf -eq $hashDest) {
            Write-Host "Skipping identical existing file: $rel"
            continue
        } else {
            throw "Refusing to overwrite modified existing file: docs/$rel"
        }
    }

    Copy-Item -LiteralPath $pf.FullName -Destination $dest -Force
    Write-Host "Injected: docs/$rel"
}

# 4. Compute src/** SHA256 After Copy
$srcHashAfter = Get-DirSrcHashes -dir $srcDir
if ($srcHashBefore -ne $srcHashAfter) {
    throw "CRITICAL ERROR: src/** SHA256 hash changed after materials injection!"
}
Write-Host "[PASS] src/** SHA256 hash verified unchanged."

# 5. Write Install Receipt to artifacts/lesson-02-evidence/
$evidenceDir = Join-Path $TargetStudentProjectDir "artifacts/lesson-02-evidence"
if (-not (Test-Path -LiteralPath $evidenceDir)) {
    New-Item -ItemType Directory -Path $evidenceDir -Force | Out-Null
}

$receipt = @{
    installedAt = (Get-Date).ToString("o")
    version = "v0.1.0"
    srcHashVerified = $true
} | ConvertTo-Json

Set-Content -Path (Join-Path $evidenceDir "materials-install-receipt.json") -Value $receipt -Encoding UTF8

Write-Host "========================================"
Write-Host "Lesson 02 Materials Package Installed Successfully!"
Write-Host "Receipt: artifacts/lesson-02-evidence/materials-install-receipt.json"
Write-Host "========================================"
