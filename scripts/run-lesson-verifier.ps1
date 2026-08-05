param(
    [int]$Step = 1,
    [string]$LogDir = "local-backups/lesson-04-evidence",
    [int]$TimeoutSeconds = 60,
    [string]$Mode = "Student"
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
Log-Message "Execution Mode: $Mode"
Log-Message "Timeout Limit: $TimeoutSeconds seconds"

$verifierFailed = $false
$exitCode = 0

function Invoke-ProcessWithTimeout([string]$cmdPath, [string]$cmdArgs, [int]$maxSeconds) {
    Log-Message "Executing: $cmdPath $cmdArgs"
    
    $stdoutFile = Join-Path $fullLogDir "proc-out.log"
    $stderrFile = Join-Path $fullLogDir "proc-err.log"
    if (Test-Path $stdoutFile) { Remove-Item $stdoutFile -Force }
    if (Test-Path $stderrFile) { Remove-Item $stderrFile -Force }

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $cmdPath
    $pinfo.Arguments = $cmdArgs
    $pinfo.WorkingDirectory = $projectRoot
    $pinfo.UseShellExecute = $false
    $pinfo.RedirectStandardOutput = $true
    $pinfo.RedirectStandardError = $true
    $pinfo.CreateNoWindow = $true

    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $pinfo

    $outList = New-Object System.Collections.Generic.List[string]
    $errList = New-Object System.Collections.Generic.List[string]

    $proc.Start() | Out-Null

    $asyncOut = $proc.StandardOutput.ReadToEndAsync()
    $asyncErr = $proc.StandardError.ReadToEndAsync()

    $completed = $proc.WaitForExit($maxSeconds * 1000)

    if (-not $completed) {
        Log-Message "TIMEOUT: Process exceeded maximum execution time ($maxSeconds seconds). Terminating process tree."
        try {
            $proc.Kill()
        } catch { }
        return @{ ExitCode = 124; Output = "TIMEOUT: Process killed after $maxSeconds seconds." }
    }

    [System.Threading.Tasks.Task]::WaitAll(@($asyncOut, $asyncErr))

    $stdOutText = $asyncOut.Result
    $stdErrText = $asyncErr.Result

    $combinedOutput = ""
    if (-not [string]::IsNullOrWhiteSpace($stdOutText)) {
        $combinedOutput += $stdOutText
    }
    if (-not [string]::IsNullOrWhiteSpace($stdErrText)) {
        $combinedOutput += "`n" + $stdErrText
    }

    return @{ ExitCode = $proc.ExitCode; Output = $combinedOutput.Trim() }
}

try {
    if ($Mode -eq "Maintainer") {
        Log-Message "--- Running Maintainer Mode Verification (verify-project.ps1) ---"
        $res = Invoke-ProcessWithTimeout "powershell.exe" "-ExecutionPolicy Bypass -File scripts/verify-project.ps1" $TimeoutSeconds
        Log-Message $res.Output
        if ($res.ExitCode -ne 0) {
            $verifierFailed = $true
            $exitCode = $res.ExitCode
        }
    } else {
        Log-Message "--- Running Student Mode Verification (verify-student-project.ps1) ---"
        $res = Invoke-ProcessWithTimeout "powershell.exe" "-ExecutionPolicy Bypass -File scripts/verify-student-project.ps1 -CourseState lesson-04" $TimeoutSeconds
        Log-Message $res.Output
        if ($res.ExitCode -ne 0) {
            $verifierFailed = $true
            $exitCode = $res.ExitCode
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
