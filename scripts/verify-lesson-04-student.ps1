param(
    [string]$CourseState = "lesson-04"
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

Write-Host "========================================"
Write-Host "Lesson 04 Student Verification ($CourseState)"
Write-Host "========================================"
Write-Host ""

# 1. Check required student files (Fail-Closed if plan file is missing)
$baseRequired = @(
    "package.json",
    "CLAUDE.md",
    "DESIGN.md",
    "docs\LESSON_04_IMPLEMENTATION_PLAN.md",
    "src\main.ts",
    "src\App.vue"
)

foreach ($f in $baseRequired) {
    if (-not (Test-Path $f)) {
        throw "Lesson 04 student verification failed: Missing required file $f"
    }
}

# 2. Check TypeScript typecheck
Write-Host "[1/4] Running TypeScript typecheck..."
$tcRaw = & cmd.exe /c "npm run typecheck 2>&1"
$tcCode = $LASTEXITCODE
if ($tcCode -ne 0) {
    throw "Lesson 04 student verification failed: Typecheck failed.`n$tcRaw"
}
Write-Host "[PASS] Typecheck clean."

# 3. Check Production build
Write-Host "[2/4] Running production build..."
$bldRaw = & cmd.exe /c "npm run build 2>&1"
$bldCode = $LASTEXITCODE
if ($bldCode -ne 0) {
    throw "Lesson 04 student verification failed: Build failed.`n$bldRaw"
}
Write-Host "[PASS] Build clean."

# 4. Check Plan Schema & State Machine (Fail-Closed)
Write-Host "[3/4] Checking LESSON_04_IMPLEMENTATION_PLAN.md State Machine Schema..."
$planContent = Get-Content "docs\LESSON_04_IMPLEMENTATION_PLAN.md" -Encoding UTF8 -Raw

if ($planContent -notmatch "plan_status:\s*(APPROVED|COMPLETED)") {
    throw "Student verification failed: LESSON_04_IMPLEMENTATION_PLAN.md must contain 'plan_status: APPROVED' or 'plan_status: COMPLETED'."
}
if ($planContent -notmatch "current_waiting_step:\s*(\d+|null)") {
    throw "Student verification failed: LESSON_04_IMPLEMENTATION_PLAN.md must contain valid 'current_waiting_step:' (integer or null)."
}
if ($planContent -notmatch "steps:") {
    throw "Student verification failed: LESSON_04_IMPLEMENTATION_PLAN.md must contain 'steps:' array."
}
if ($planContent -notmatch "allowed_files:" -or $planContent -notmatch "acceptance:") {
    throw "Student verification failed: LESSON_04_IMPLEMENTATION_PLAN.md steps must define 'allowed_files:' and 'acceptance:' fields."
}
Write-Host "[PASS] Plan State Machine Schema valid."

# 5. Check Vue Business Component for prototypeState & 4 States
Write-Host "[4/4] Checking Vue Component for prototypeState 4-state debug toggle..."
$vueFiles = Get-ChildItem -Path "src" -Filter "*.vue" -Recurse

$foundDebugToggle = $false
$foundAllFourStates = $false

foreach ($vf in $vueFiles) {
    $c = Get-Content $vf.FullName -Encoding UTF8 -Raw
    if ($c -match "prototypeState") {
        $foundDebugToggle = $true
        if (($c -match "import\.meta\.env\.DEV" -or $c -match "showPrototypeDebug") -and $c -match "loading" -and $c -match "empty" -and $c -match "error" -and $c -match "success") {
            $foundAllFourStates = $true
            break
        }
    }
}

if ($foundDebugToggle) {
    if (-not $foundAllFourStates) {
        throw "Lesson 04 student verification failed: Vue component containing prototypeState must define import.meta.env.DEV protection and all 4 states ('loading', 'empty', 'error', 'success')."
    }
    Write-Host "[PASS] Component prototypeState debug toggle and 4-state assertion passed."
} else {
    Write-Host "[INFO] prototypeState debug toggle assertion ready for Task 2."
}

Write-Host ""
Write-Host "========================================"
Write-Host "Lesson 04 Student Verification Complete: PASS"
Write-Host "========================================"
