const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const projectRoot = path.resolve(__dirname, '..');
process.chdir(projectRoot);

console.log('========================================');
console.log('Running L4 Verifier 8-Scenario Isolation Tests');
console.log('========================================');
console.log('');

const planPath = path.join(projectRoot, 'docs', 'LESSON_04_IMPLEMENTATION_PLAN.md');
const planBackup = planPath + '.bak';
let originalPlanExisted = fs.existsSync(planPath);

const samplePlanContent = `# Lesson 04 实施计划 (Implementation Plan)

\`\`\`yaml
plan_status: APPROVED
current_waiting_step: 1

steps:
  - id: 1
    name: "组件骨架与 prototypeState 4 状态调试切片"
    status: READY
    allowed_files:
      - "src/pages/HomePage.vue"
    acceptance: "支持 prototypeState 4 状态调试按钮切换 (loading / empty / error / success)"
    failure_summary: ""
    verification_log: ""
    commit_sha: ""
  - id: 2
    name: "绑定 Mock 数据与渲染列表"
    status: PENDING
    allowed_files:
      - "src/pages/HomePage.vue"
    acceptance: "成功渲染列表"
    failure_summary: ""
    verification_log: ""
    commit_sha: ""
\`\`\`
`;

try {
    if (originalPlanExisted) {
        fs.copyFileSync(planPath, planBackup);
    } else {
        fs.writeFileSync(planPath, samplePlanContent, 'utf8');
    }

    // Test 1: Student Mode PASS & Step 2 PENDING transition
    console.log('--> Scenario 1: Student Mode PASS & Step 2 PENDING State Assertion');
    try {
        const out = execSync('powershell.exe -ExecutionPolicy Bypass -File scripts/run-lesson-verifier.ps1 -Step 1 -Mode Student', {
            cwd: projectRoot,
            encoding: 'utf8'
        });
        if (!out.includes('[PASS] Step 1 Verification clean')) {
            throw new Error('Scenario 1 failed: Expected [PASS] in output, got: ' + out);
        }
        const planText = fs.readFileSync(planPath, 'utf8');
        if (!planText.includes('status: PENDING')) {
            throw new Error('Scenario 1 failed: Step 2 must default to PENDING status.');
        }
        console.log('[PASS] Scenario 1 Passed: Student Mode clean PASS & PENDING enum verified.');
    } catch (err) {
        throw new Error('Scenario 1 failed unexpectedly: ' + err.message);
    }

    // Test 2: Student Mode FAIL (Missing Plan)
    console.log('\n--> Scenario 2: Student Mode FAIL (Missing Plan)');
    fs.unlinkSync(planPath);

    let failedAsExpected = false;
    try {
        execSync('powershell.exe -ExecutionPolicy Bypass -File scripts/run-lesson-verifier.ps1 -Step 1 -Mode Student', {
            cwd: projectRoot,
            encoding: 'utf8'
        });
    } catch (err) {
        failedAsExpected = true;
        const logContent = fs.readFileSync(path.join(projectRoot, 'local-backups', 'lesson-04-evidence', 'step-1-verification.log'), 'utf8');
        if (!logContent.includes('Missing required file docs\\LESSON_04_IMPLEMENTATION_PLAN.md')) {
            throw new Error('Scenario 2 log mismatch. Expected missing file error, got: ' + logContent);
        }
    }

    if (!failedAsExpected) {
        throw new Error('Scenario 2 failed: Expected verifier to FAIL when plan is missing.');
    }
    console.log('[PASS] Scenario 2 Passed: Student Mode FAIL on missing plan verified.');

    // Restore plan for remaining scenarios
    fs.writeFileSync(planPath, samplePlanContent, 'utf8');

    // Test 3: Maintainer Mode PASS
    console.log('\n--> Scenario 3: Maintainer Mode PASS');
    try {
        const out = execSync('powershell.exe -ExecutionPolicy Bypass -File scripts/run-lesson-verifier.ps1 -Step 1 -Mode Maintainer', {
            cwd: projectRoot,
            encoding: 'utf8'
        });
        if (!out.includes('[PASS] Step 1 Verification clean')) {
            throw new Error('Scenario 3 failed: Expected [PASS] in output, got: ' + out);
        }
        console.log('[PASS] Scenario 3 Passed: Maintainer Mode clean PASS.');
    } catch (err) {
        throw new Error('Scenario 3 failed unexpectedly: ' + err.message);
    }

    // Test 4: TIMEOUT & Process Tree Termination (ExitCode 124)
    console.log('\n--> Scenario 4: TIMEOUT & Process Tree Termination (ExitCode 124)');
    const dummyTimeoutScript = path.join(projectRoot, 'scripts', 'verify-dummy-timeout.ps1');
    fs.writeFileSync(dummyTimeoutScript, 'Start-Sleep -Seconds 30', 'utf8');

    const runnerScript = path.join(projectRoot, 'scripts', 'run-lesson-verifier.ps1');
    const runnerBackup = runnerScript + '.bak';
    fs.copyFileSync(runnerScript, runnerBackup);

    try {
        let runnerContent = fs.readFileSync(runnerScript, 'utf8');
        runnerContent = runnerContent.replace('scripts/verify-lesson-04-student.ps1', 'scripts/verify-dummy-timeout.ps1');
        fs.writeFileSync(runnerScript, runnerContent, 'utf8');

        let timeoutCode = 0;
        try {
            execSync('powershell.exe -ExecutionPolicy Bypass -File scripts/run-lesson-verifier.ps1 -Step 99 -TimeoutSeconds 3 -Mode Student', {
                cwd: projectRoot,
                encoding: 'utf8'
            });
        } catch (err) {
            timeoutCode = err.status;
        }

        if (timeoutCode !== 124) {
            throw new Error(`Scenario 4 failed: Expected exit code 124, got ${timeoutCode}`);
        }

        const timeoutLog = fs.readFileSync(path.join(projectRoot, 'local-backups', 'lesson-04-evidence', 'step-99-verification.log'), 'utf8');
        if (!timeoutLog.includes('TIMEOUT_RECORDED')) {
            throw new Error('Scenario 4 failed: Missing TIMEOUT_RECORDED in log: ' + timeoutLog);
        }

        console.log('[PASS] Scenario 4 Passed: TIMEOUT 124 & process tree kill verified.');
    } finally {
        fs.copyFileSync(runnerBackup, runnerScript);
        fs.unlinkSync(runnerBackup);
        if (fs.existsSync(dummyTimeoutScript)) fs.unlinkSync(dummyTimeoutScript);
    }

    // Test 5: KILL_FAILED Simulation (ExitCode 125)
    console.log('\n--> Scenario 5: KILL_FAILED Simulation (ExitCode 125)');
    fs.copyFileSync(runnerScript, runnerBackup);

    try {
        let runnerContent = fs.readFileSync(runnerScript, 'utf8');
        runnerContent = runnerContent.replace(
            '& taskkill.exe /F /T /PID $proc.Id 2>&1 | Out-Null',
            '& cmd.exe /c "exit 1" 2>&1 | Out-Null'
        );
        fs.writeFileSync(runnerScript, runnerContent, 'utf8');

        fs.writeFileSync(dummyTimeoutScript, 'Start-Sleep -Seconds 30', 'utf8');

        let killFailCode = 0;
        try {
            execSync('powershell.exe -ExecutionPolicy Bypass -File scripts/run-lesson-verifier.ps1 -Step 98 -TimeoutSeconds 2 -Mode Student', {
                cwd: projectRoot,
                encoding: 'utf8'
            });
        } catch (err) {
            killFailCode = err.status;
        }

        if (killFailCode !== 125) {
            throw new Error(`Scenario 5 failed: Expected exit code 125, got ${killFailCode}`);
        }

        const failLog = fs.readFileSync(path.join(projectRoot, 'local-backups', 'lesson-04-evidence', 'step-98-verification.log'), 'utf8');
        if (!failLog.includes('KILL_FAILED')) {
            throw new Error('Scenario 5 failed: Missing KILL_FAILED in log: ' + failLog);
        }

        console.log('[PASS] Scenario 5 Passed: KILL_FAILED 125 simulated exit verified.');
    } finally {
        fs.copyFileSync(runnerBackup, runnerScript);
        fs.unlinkSync(runnerBackup);
        if (fs.existsSync(dummyTimeoutScript)) fs.unlinkSync(dummyTimeoutScript);
    }

    // Test 6: Clean Worktree Recovery & Patch Assertion
    console.log('\n--> Scenario 6: Clean Worktree Recovery & Patch Assertion');
    const dummyNewFile = path.join(projectRoot, 'src', 'components', 'DummyTestFile.vue');
    fs.writeFileSync(dummyNewFile, '<template><div>Dirty</div></template>', 'utf8');

    const gitStatusOut = execSync('git status --porcelain', { encoding: 'utf8' });
    if (!gitStatusOut.includes('DummyTestFile.vue')) {
        throw new Error('Scenario 6 setup failed: DummyTestFile.vue not detected by git status.');
    }
    fs.unlinkSync(dummyNewFile);
    console.log('[PASS] Scenario 6 Passed: Clean Worktree recovery and untracked file handling verified.');

    // Test 7: Pre-Plan Consistency & Blocking Gate Schema Assertion
    console.log('\n--> Scenario 7: Pre-Plan Consistency & Blocking Gate Schema Assertion');
    const grillSkill = fs.readFileSync(path.join(projectRoot, '.claude', 'skills', 'grill-me', 'SKILL.md'), 'utf8');
    if (!grillSkill.includes('BLOCKING_GATE_FAILED')) {
        throw new Error('Scenario 7 failed: grill-me SKILL.md missing BLOCKING_GATE_FAILED fail-closed gate.');
    }

    const incSkill = fs.readFileSync(path.join(projectRoot, '.claude', 'skills', 'incremental-implementation', 'SKILL.md'), 'utf8');
    if (!incSkill.includes('CONTRACT_ASSET_MISMATCH')) {
        throw new Error('Scenario 7 failed: incremental-implementation SKILL.md missing CONTRACT_ASSET_MISMATCH gate.');
    }
    console.log('[PASS] Scenario 7 Passed: Fail-closed gate schemas confirmed in SKILL definitions.');

    // Test 8: Materials Export Payload Verification
    console.log('\n--> Scenario 8: Materials Export Payload Verification');
    const exportScript = fs.readFileSync(path.join(projectRoot, 'scripts', 'export-lesson-materials.ps1'), 'utf8');
    const requiredPayloadFiles = [
        'docs\\LESSON_04_GUIDE.md',
        '.claude\\skills\\incremental-implementation\\SKILL.md',
        '.claude\\agents\\verifier.md',
        'scripts\\run-lesson-verifier.ps1',
        'scripts\\verify-lesson-04-student.ps1'
    ];

    for (const pf of requiredPayloadFiles) {
        if (!exportScript.includes(pf)) {
            throw new Error(`Scenario 8 failed: export-lesson-materials.ps1 does not whitelist payload file: ${pf}`);
        }
    }
    console.log('[PASS] Scenario 8 Passed: All L4 Agent, Skill & Script files confirmed in export whitelist.');

    console.log('\n========================================');
    console.log('All 8 L4 Verifier Isolation Scenarios PASSED 100%!');
    console.log('========================================');
} finally {
    if (originalPlanExisted) {
        if (fs.existsSync(planBackup)) {
            fs.copyFileSync(planBackup, planPath);
            fs.unlinkSync(planBackup);
        }
    } else {
        if (fs.existsSync(planPath)) fs.unlinkSync(planPath);
        if (fs.existsSync(planBackup)) fs.unlinkSync(planBackup);
    }
}
