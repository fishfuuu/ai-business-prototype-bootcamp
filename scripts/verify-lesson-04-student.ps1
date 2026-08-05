param(
    [string]$CourseState = "lesson-04"
)

$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

Write-Host "========================================"
Write-Host "Lesson 04 Student Verification ($CourseState)"
Write-Host "========================================"
Write-Host ""

# 1. Check base required student files
$baseRequired = @(
    "package.json",
    "CLAUDE.md",
    "DESIGN.md",
    "src\main.ts",
    "src\App.vue"
)

foreach ($f in $baseRequired) {
    if (-not (Test-Path $f)) {
        throw "Lesson 04 student verification failed: Missing required file $f"
    }
}

# 2. Check TypeScript typecheck
Write-Host "[1/3] Running TypeScript typecheck..."
$tcRaw = & cmd.exe /c "npm run typecheck 2>&1"
$tcCode = $LASTEXITCODE
if ($tcCode -ne 0) {
    throw "Lesson 04 student verification failed: Typecheck failed.`n$tcRaw"
}
Write-Host "[PASS] Typecheck clean."

# 3. Check Production build
Write-Host "[2/3] Running production build..."
$bldRaw = & cmd.exe /c "npm run build 2>&1"
$bldCode = $LASTEXITCODE
if ($bldCode -ne 0) {
    throw "Lesson 04 student verification failed: Build failed.`n$bldRaw"
}
Write-Host "[PASS] Build clean."

# 4. Check Plan Schema if present
Write-Host "[3/3] Running Lesson 04 student assertions..."
if (Test-Path "docs\LESSON_04_IMPLEMENTATION_PLAN.md") {
    $planContent = Get-Content "docs\LESSON_04_IMPLEMENTATION_PLAN.md" -Encoding UTF8 -Raw
    if ($planContent -notmatch "plan_status:\s*APPROVED") {
        throw "Student verification failed: LESSON_04_IMPLEMENTATION_PLAN.md must contain 'plan_status: APPROVED'."
    }
    if ($planContent -notmatch "current_waiting_step:") {
        throw "Student verification failed: LESSON_04_IMPLEMENTATION_PLAN.md must contain 'current_waiting_step:'."
    }
    Write-Host "[PASS] Plan State Machine Schema valid."
} else {
    Write-Host "[INFO] LESSON_04_IMPLEMENTATION_PLAN.md is not created yet (Waiting for Task 1)."
}

Write-Host ""
Write-Host "========================================"
Write-Host "Lesson 04 Student Verification Complete: PASS"
Write-Host "========================================"
