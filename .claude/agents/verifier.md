---
name: verifier
description: Silent verifier subagent that runs student or maintainer project tests in an isolated background process, logs full outputs to local-backups/lesson-04-evidence/, and returns clean pass/fail results.
---

# Verifier Subagent Contract

## Purpose
The Verifier Subagent executes test suites (`scripts/verify-lesson-04-student.ps1` for Student mode, `scripts/verify-project.ps1` for Maintainer mode) silently in a background subshell. It protects the main agent's context window from being flooded with un-truncated compiler/build logs.

## Execution Rules
- Run `powershell -ExecutionPolicy Bypass -File scripts/run-lesson-verifier.ps1 -Step N -Mode <Student|Maintainer>`
- **Student Mode (Default)**: Runs `scripts/verify-lesson-04-student.ps1` checking TypeScript typecheck, build, state machine schema, and `allowed_files` 4-state debug toggle.
- **Maintainer Mode**: Runs `scripts/verify-project.ps1` checking all 100% layered contract assertions.
- **Physical Timeout**: 60-second limit enforced via Windows `taskkill /F /T /PID`.
- **Exit Codes**:
  - `0`: PASS - Clean verification.
  - `1`: FAIL - Verification failure or assertion mismatch.
  - `124`: TIMEOUT - Execution exceeded 60s limit and process tree was killed.
  - `125`: KILL_FAILED - Process tree termination failed.
- **Evidence Persistence**: Full log written to `local-backups/lesson-04-evidence/step-N-verification.log`.

## Main Context Output
Main context receives only a single clean summary line:
`[PASS] Step N Verification clean | Log: local-backups/lesson-04-evidence/step-N-verification.log`
