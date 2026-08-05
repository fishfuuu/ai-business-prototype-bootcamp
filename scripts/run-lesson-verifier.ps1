param(
    [int]$Step = 1,
    [string]$LogDir = "local-backups/lesson-04-evidence",
    [int]$TimeoutSeconds = 60
)

$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

if ([System.IO.Path]::IsPathRooted($LogDir)) {
    $fullLogDir = [System.IO.Path]::GetFullPath($LogDir)
} else {
    $fullLogDir = Join-Path $projectRoot $LogDir
}

if (-not (Test-Path $fullLogDir)) {
    New-Item -ItemType Directory -Path $fullLogDir -Force | Out-Null
}

$logFilePath = Join-Path $fullLogDir "step-$Step-verification.log"
$logOutput = New-Object System.Collections.Generic.List[string]

function Log-Message([string]$msg) {
    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $line = "[$timestamp] $msg"
    $script:logOutput.Add($line)
}

Log-Message "Starting Verifier Execution for Lesson 04 Step $Step"
Log-Message "Target Directory: $projectRoot"
Log-Message "Timeout Limit: $TimeoutSeconds seconds"
Log-Message "Allowed Scope: npm run typecheck, npm run build, verify-project.ps1"
Log-Message "Forbidden Scope: Modifying src/, docs/, test assertions, configs, auto-fix, auto-git-commit"

$verifierFailed = $false
$exitCode = 0

try {
    # Task 1: Typecheck
    Log-Message "--- Running Task 1: npm run typecheck ---"
    $tcResult = & npm.cmd run typecheck 2>&1
    $tcCode = $LASTEXITCODE
    if ($tcResult) { $tcResult | ForEach-Object { Log-Message "OUTPUT: $_" } }
    
    if ($tcCode -ne 0) {
        $verifierFailed = $true
        $exitCode = $tcCode
        Log-Message "FAIL: typecheck exited with code $tcCode"
    } else {
        Log-Message "PASS: typecheck clean"
    }

    # Task 2: Build
    if (-not $verifierFailed) {
        Log-Message "--- Running Task 2: npm run build ---"
        $bldResult = & npm.cmd run build 2>&1
        $bldCode = $LASTEXITCODE
        if ($bldResult) { $bldResult | ForEach-Object { Log-Message "OUTPUT: $_" } }
        
        if ($bldCode -ne 0) {
            $verifierFailed = $true
            $exitCode = $bldCode
            Log-Message "FAIL: build exited with code $bldCode"
        } else {
            Log-Message "PASS: build clean"
        }
    }

    # Task 3: verify-project.ps1
    if (-not $verifierFailed) {
        Log-Message "--- Running Task 3: verify-project.ps1 ---"
        $vpResult = & powershell.exe -ExecutionPolicy Bypass -File "scripts/verify-project.ps1" 2>&1
        $vpCode = $LASTEXITCODE
        if ($vpResult) { $vpResult | ForEach-Object { Log-Message "OUTPUT: $_" } }
        
        if ($vpCode -ne 0) {
            $verifierFailed = $true
            $exitCode = $vpCode
            Log-Message "FAIL: verify-project.ps1 exited with code $vpCode"
        } else {
            Log-Message "PASS: verify-project.ps1 clean"
        }
    }

} catch {
    $verifierFailed = $true
    $exitCode = 1
    Log-Message "EXCEPTION: $($_.Exception.Message)"
} finally {
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllLines($logFilePath, $logOutput, $utf8NoBom)
    
    $relLogPath = "local-backups/lesson-04-evidence/step-$Step-verification.log"
    if ($verifierFailed) {
        Write-Host "[FAIL] Step $Step Verification failed (ExitCode=$exitCode) | Log: $relLogPath"
        exit $exitCode
    } else {
        Write-Host "[PASS] Step $Step Verification clean | Log: $relLogPath"
        exit 0
    }
}
