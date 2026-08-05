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

function Invoke-ProcessTreeWithTimeout([string]$commandLine, [int]$maxSeconds) {
    Log-Message "Executing: $commandLine"
    
    $outTempFile = Join-Path $fullLogDir "temp-raw-$([Guid]::NewGuid().ToString('N')).log"
    
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "cmd.exe"
    $pinfo.Arguments = "/c $commandLine > `"$outTempFile`" 2>&1"
    $pinfo.WorkingDirectory = $projectRoot
    $pinfo.UseShellExecute = $false
    $pinfo.CreateNoWindow = $true

    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $pinfo
    $proc.Start() | Out-Null

    $completed = $proc.WaitForExit($maxSeconds * 1000)

    if (-not $completed) {
        Log-Message "TIMEOUT: Execution exceeded $maxSeconds seconds. Recursively terminating process tree (PID: $($proc.Id))."
        
        # Kill process tree using taskkill
        & taskkill.exe /F /T /PID $proc.Id 2>&1 | Out-Null
        $killExitCode = $LASTEXITCODE

        if ($killExitCode -ne 0) {
            Log-Message "KILL_FAILED: taskkill exited with non-zero code $killExitCode. Attempting fallback process kill."
            try { $proc.Kill() } catch { }
            
            if (Test-Path $outTempFile) {
                Remove-Item $outTempFile -Force -ErrorAction SilentlyContinue
            }
            return @{ ExitCode = 125; Output = "KILL_FAILED: Process tree termination failed with code $killExitCode." }
        }

        $proc.WaitForExit(5000)

        if (-not $proc.HasExited) {
            Log-Message "KILL_FAILED: Process still running after taskkill."
            return @{ ExitCode = 125; Output = "KILL_FAILED: Process still running after taskkill." }
        }

        # Read any partial output collected before timeout
        if (Test-Path $outTempFile) {
            $partial = Get-Content $outTempFile -ErrorAction SilentlyContinue
            if ($partial) { $partial | ForEach-Object { Log-Message "PARTIAL STDOUT/STDERR: $_" } }
            Remove-Item $outTempFile -Force -ErrorAction SilentlyContinue
        }

        Log-Message "TIMEOUT_RECORDED: Process tree successfully killed after $maxSeconds seconds."
        return @{ ExitCode = 124; Output = "TIMEOUT: Killed process tree after $maxSeconds seconds." }
    }

    $rawContent = ""
    if (Test-Path $outTempFile) {
        $rawContent = Get-Content $outTempFile -Raw -ErrorAction SilentlyContinue
        Remove-Item $outTempFile -Force -ErrorAction SilentlyContinue
    }

    return @{ ExitCode = $proc.ExitCode; Output = $rawContent }
}

try {
    if ($Mode -eq "Maintainer") {
        $cmd = "powershell.exe -ExecutionPolicy Bypass -File scripts/verify-project.ps1"
    } elseif ($Mode -eq "Student") {
        $cmd = "powershell.exe -ExecutionPolicy Bypass -File scripts/verify-lesson-04-student.ps1 -CourseState lesson-04"
    } else {
        throw "Unsupported Mode: $Mode"
    }
    
    $res = Invoke-ProcessTreeWithTimeout $cmd $TimeoutSeconds
    Log-Message $res.Output

    if ($res.ExitCode -ne 0) {
        $verifierFailed = $true
        $exitCode = $res.ExitCode
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
