param(
    [string]$CourseState = "lesson-04"
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

Write-Host "========================================"
Write-Host "Student Project Verification ($CourseState)"
Write-Host "========================================"
Write-Host ""

# 1. Base required student files
$baseRequired = @(
    "package.json",
    "CLAUDE.md",
    "DESIGN.md",
    "src\main.ts",
    "src\App.vue"
)

foreach ($f in $baseRequired) {
    if (-not (Test-Path $f)) {
        throw "Student verification failed: Missing file $f"
    }
}

# 2. Check TypeScript build & typecheck
Write-Host "[1/3] Running TypeScript typecheck..."
$tcResult = & npm.cmd run typecheck 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "Student verification failed: Typecheck failed.`n$tcResult"
}
Write-Host "[PASS] Typecheck clean."

Write-Host "[2/3] Running production build..."
$bldResult = & npm.cmd run build 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "Student verification failed: Build failed.`n$bldResult"
}
Write-Host "[PASS] Build clean."

# 3. Lesson 04 specific student assertions
if ($CourseState -eq "lesson-04") {
    Write-Host "[3/3] Running Lesson 04 student contract assertions..."
    
    $l4Required = @(
        "docs\BUSINESS_FEATURE_CARD.md",
        "src\types\prototype-contract.d.ts",
        "src\mocks\prototype-data.ts",
        "docs\LESSON_04_IMPLEMENTATION_PLAN.md"
    )
    
    foreach ($f in $l4Required) {
        if (-not (Test-Path $f)) {
            throw "Student verification failed for Lesson 04: Missing file $f"
        }
    }
    
    $planContent = Get-Content "docs\LESSON_04_IMPLEMENTATION_PLAN.md" -Encoding UTF8 -Raw
    if ($planContent -notmatch "plan_status:\s*APPROVED") {
        throw "Student verification failed: LESSON_04_IMPLEMENTATION_PLAN.md must contain 'plan_status: APPROVED'."
    }
    if ($planContent -notmatch "current_waiting_step:") {
        throw "Student verification failed: LESSON_04_IMPLEMENTATION_PLAN.md must contain 'current_waiting_step:' field."
    }
    
    Write-Host "[PASS] Lesson 04 student contract assertions passed."
}

Write-Host ""
Write-Host "========================================"
Write-Host "Student Verification Complete: PASS"
Write-Host "========================================"
