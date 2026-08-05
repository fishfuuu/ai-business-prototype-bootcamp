$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot

Write-Host "========================================"
Write-Host "AI Business Prototype Verification"
Write-Host "========================================"
Write-Host ""

Set-Location $projectRoot

Write-Host "[1/5] Checking required files..."

$requiredFiles = @(
    "package.json",
    "package-lock.json",
    "vite.config.ts",
    "tsconfig.json",
    "index.html",
    "CLAUDE.md",
    "DESIGN.md",
    "README.md",
    "docs\COURSE_ROADMAP.md",
    "docs\PROJECT_STATE.md",
    "docs\COMPONENT_CATALOG.md",
    "docs\LESSON_01_GUIDE.md",
    "docs\LESSON_01_TEACHER_PLAN.md",
    "docs\assets\lesson-01\lesson-01-flow.png",
    "docs\LESSON_02_GUIDE.md",
    "docs\LESSON_02_TEACHER_PLAN.md",
    "docs\LESSON_02_MATERIALS_PACKAGE_ADDENDUM.md",
    "docs\assets\lesson-02\lesson-02-flow.png",
    "docs\assets\lesson-02\ref-monitor-decision.png",
    "docs\assets\lesson-02\ref-task-workflow.png",
    "docs\assets\lesson-02\ref-operation-tool.png",
    "docs\LESSON_03_GUIDE.md",
    "docs\LESSON_03_TEACHER_PLAN.md",
    ".claude\skills\grill-me\SKILL.md",
    "docs\LESSON_04_GUIDE.md",
    "docs\LESSON_04_TEACHER_PLAN.md",
    ".claude\skills\incremental-implementation\SKILL.md",
    ".claude\agents\verifier.md",
    "scripts\run-lesson-verifier.ps1",
    "scripts\verify-lesson-04-student.ps1",
    "scripts\run-l4-verifier-isolation-tests.cjs",
    "skills-lock.json",
    "src\main.ts",
    "src\App.vue",
    "src\router\index.ts"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        throw "Required file is missing: $file"
    }
}

if (-not (Test-Path "node_modules")) {
    throw "node_modules is missing. Run npm install first."
}

# Assert out-of-scope find-skills is removed
if (Test-Path ".claude\skills\find-skills\SKILL.md") {
    throw "Prohibited out-of-scope Skill found: .claude/skills/find-skills/SKILL.md must be removed from Lessons 01-04 PR."
}

# Verify Teacher Plan 22-section structure for Lesson 02, 03, 04
$tp2 = Get-Content "docs\LESSON_02_TEACHER_PLAN.md" -Encoding UTF8 -Raw
for ($s=1; $s -le 22; $s++) {
    if ($tp2 -notmatch "## $s\.") {
        throw "LESSON_02_TEACHER_PLAN.md is missing section header: ## $s."
    }
}

$tp3 = Get-Content "docs\LESSON_03_TEACHER_PLAN.md" -Encoding UTF8 -Raw
for ($s=1; $s -le 22; $s++) {
    if ($tp3 -notmatch "## $s\.") {
        throw "LESSON_03_TEACHER_PLAN.md is missing section header: ## $s."
    }
}

$tp4 = Get-Content "docs\LESSON_04_TEACHER_PLAN.md" -Encoding UTF8 -Raw
for ($s=1; $s -le 22; $s++) {
    if ($tp4 -notmatch "## $s\.") {
        throw "LESSON_04_TEACHER_PLAN.md is missing section header: ## $s."
    }
}

Write-Host "[PASS] Required files are present and Teacher Plans match 22-section structure."
Write-Host ""

Write-Host "[1.5/5] Running Layered Contract Assertions across Roadmap & Execution Docs..."

# 1. Authoritative Roadmap (COURSE_ROADMAP.md) Contract Assertions
$authRoadmap = Get-Content "docs\COURSE_ROADMAP.md" -Encoding UTF8 -Raw

$roadmapContracts = @(
    "唯一权威执行版",
    "单次指令",
    "工程护栏",
    "受控 Agent 循环",
    "工作记忆",
    "外部长期记忆",
    "版本证据",
    "Grounding",
    "确定性",
    "概率性",
    "可重复验证",
    "回归风险",
    "受控 AI 功能闭环",
    "独立审查上下文隔离",
    "最多 2 轮"
)

foreach ($kw in $roadmapContracts) {
    if ($authRoadmap -notmatch [regex]::Escape($kw)) {
        throw "Authoritative COURSE_ROADMAP.md is missing contract term: $kw"
    }
}

# 2. Manuscript Disclaimer Check
$manuscript = Get-Content "docs\主管 AI 原型制作训练营.md" -Encoding UTF8 -Raw
if ($manuscript -notmatch "COURSE_ROADMAP\.md") {
    throw "Manuscript is missing reference to authoritative COURSE_ROADMAP.md"
}

# 3. PROJECT_STATE.md Contract Assertions
$projectState = Get-Content "docs\PROJECT_STATE.md" -Encoding UTF8 -Raw
if ($projectState -match "L01.*\| PASS") {
    throw "PROJECT_STATE.md should not default lesson statuses to PASS."
}
if ($projectState -notmatch "待开始") {
    throw "PROJECT_STATE.md must default lesson statuses to '待开始'."
}
if ($projectState -match "\[x\] 使用模拟数据") {
    throw "PROJECT_STATE.md checkboxes should default to unchecked '[ ]'."
}
if ($projectState -match "\.env\.local") {
    throw "PROJECT_STATE.md contains prohibited '.env.local' string."
}

# 4. Lesson 01 Layered Assertions
$l1Guide = Get-Content "docs\LESSON_01_GUIDE.md" -Encoding UTF8 -Raw
if ($l1Guide -notmatch "PROJECT_STATE\.md") {
    throw "LESSON_01_GUIDE.md missing PROJECT_STATE.md step."
}
if ($l1Guide -notmatch "Tools 权限沙箱") {
    throw "LESSON_01_GUIDE.md missing Tools permission sandboxing explanation."
}
if ($l1Guide -notmatch "lesson-01-flow\.png") {
    throw "LESSON_01_GUIDE.md image link must point to lesson-01-flow.png."
}

$l1TeacherPlan = Get-Content "docs\LESSON_01_TEACHER_PLAN.md" -Encoding UTF8 -Raw
if ($l1TeacherPlan -notmatch "本课学员 Skill 名称 \| 无") {
    throw "LESSON_01_TEACHER_PLAN.md must declare student Skill as None (无)."
}

# 5. Lesson 02 Layered Assertions
$l2Guide = Get-Content "docs\LESSON_02_GUIDE.md" -Encoding UTF8 -Raw
if ($l2Guide -match "commit -am") {
    throw "LESSON_02_GUIDE.md contains dangerous 'commit -am' command."
}
if ($l2Guide -match "git checkout \.") {
    throw "LESSON_02_GUIDE.md contains dangerous 'git checkout .' command."
}
if ($l2Guide -notmatch "Discard Changes") {
    throw "LESSON_02_GUIDE.md missing Discard Changes UI instructions."
}
if ($l2Guide -notmatch "tailwind\.css") {
    throw "LESSON_02_GUIDE.md must explain runtime CSS Tokens in tailwind.css."
}
if ($l2Guide -cmatch 'var\(--art-Primary\)') {
    throw "LESSON_02_GUIDE.md contains invalid uppercase CSS variable. Must be lowercase."
}

# 6. Lesson 03 Layered Assertions
$l3Guide = Get-Content "docs\LESSON_03_GUIDE.md" -Encoding UTF8 -Raw
if ($l3Guide -notmatch "grill-me") {
    throw "LESSON_03_GUIDE.md missing grill-me Skill reference."
}
if ($l3Guide -notmatch "数据契约") {
    throw "LESSON_03_GUIDE.md missing Data Contract reference."
}
if ($l3Guide -notmatch "verify-student-project\.ps1" -and $l3Guide -notmatch "verify-lesson-04-student\.ps1") {
    throw "LESSON_03_GUIDE.md must reference student verification script execution."
}
if ($l3Guide -match "cd d:\\AILearning") {
    throw "LESSON_03_GUIDE.md contains prohibited hardcoded path d:\AILearning."
}
if ($l3Guide -notmatch "Task 3A") {
    throw "LESSON_03_GUIDE.md must contain explicit Task 3A read-only preview step."
}

$l3TeacherPlan = Get-Content "docs\LESSON_03_TEACHER_PLAN.md" -Encoding UTF8 -Raw
if ($l3TeacherPlan -notmatch "Task 3A/3B") {
    throw "LESSON_03_TEACHER_PLAN.md must synchronize Task 3A/3B HITL workflow."
}

# 7. Lesson 04 Layered Assertions
$l4Guide = Get-Content "docs\LESSON_04_GUIDE.md" -Encoding UTF8 -Raw
if ($l4Guide -notmatch "incremental-implementation") {
    throw "LESSON_04_GUIDE.md missing incremental-implementation skill reference."
}
if ($l4Guide -notmatch "LESSON_04_IMPLEMENTATION_PLAN\.md") {
    throw "LESSON_04_GUIDE.md must reference persistent plan docs/LESSON_04_IMPLEMENTATION_PLAN.md."
}
if ($l4Guide -notmatch "授权执行 Step") {
    throw "LESSON_04_GUIDE.md must instruct student to use '授权执行 Step N' authorization gate."
}
if ($l4Guide -notmatch "授权提交 Step.*源码") {
    throw "LESSON_04_GUIDE.md must instruct student to use Two-Commit Protocol (授权提交 Step N 源码)."
}
if ($l4Guide -notmatch "授权提交 Step.*状态推进") {
    throw "LESSON_04_GUIDE.md must instruct student to use Two-Commit Protocol (授权提交 Step N 状态推进)."
}
if ($l4Guide -notmatch "git add --") {
    throw "LESSON_04_GUIDE.md must instruct student on selective staging (git add --)."
}
if ($l4Guide -notmatch "prototypeState") {
    throw "LESSON_04_GUIDE.md must explain prototypeState debug toggle."
}
if ($l4Guide -notmatch "Verifier Subagent") {
    throw "LESSON_04_GUIDE.md must reference Verifier Subagent execution."
}
if ($l4Guide -notmatch "src/mocks/prototype-data\.ts") {
    throw "LESSON_04_GUIDE.md must use frozen mock path src/mocks/prototype-data.ts."
}

$l4TeacherPlan = Get-Content "docs\LESSON_04_TEACHER_PLAN.md" -Encoding UTF8 -Raw
if ($l4TeacherPlan -notmatch "草稿V2 / 待合入") {
    throw "LESSON_04_TEACHER_PLAN.md status must default to '草稿V2 / 待合入'."
}
if ($l4TeacherPlan -notmatch "待指定") {
    throw "LESSON_04_TEACHER_PLAN.md owner must default to '待指定'."
}
if ($l4TeacherPlan -notmatch "src/mocks/prototype-data\.ts") {
    throw "LESSON_04_TEACHER_PLAN.md must use frozen mock path src/mocks/prototype-data.ts."
}
if ($l4TeacherPlan -match "\[x\] 页面实际操作") {
    throw "LESSON_04_TEACHER_PLAN.md checkboxes must default to unchecked [ ]."
}

# 8. Skill File Input Path & Selective Two-Commit Protocol Assertions
$l4Skill = Get-Content ".claude\skills\incremental-implementation\SKILL.md" -Encoding UTF8 -Raw
if ($l4Skill -notmatch "docs/BUSINESS_FEATURE_CARD\.md") {
    throw "SKILL.md must specify full path docs/BUSINESS_FEATURE_CARD.md instead of bare filename."
}
if ($l4Skill -notmatch "git add --") {
    throw "SKILL.md must specify selective staging rule (git add --)."
}
if ($l4Skill -notmatch "授权提交 Step.*源码") {
    throw "SKILL.md must define Two-Commit protocol (授权提交 Step N 源码)."
}
if ($l4Skill -notmatch "授权提交 Step.*状态推进") {
    throw "SKILL.md must define Two-Commit protocol (授权提交 Step N 状态推进)."
}
if ($l4Skill -notmatch "plan_status:\s*COMPLETED") {
    throw "SKILL.md must define final step transition to plan_status: COMPLETED."
}

# 9. Verifier Runner Execution & Timeout Assertions
$runnerScript = Get-Content "scripts\run-lesson-verifier.ps1" -Encoding UTF8 -Raw
if ($runnerScript -notmatch "taskkill\.exe") {
    throw "run-lesson-verifier.ps1 must implement recursive process tree termination via taskkill.exe."
}
if ($runnerScript -notmatch "TimeoutSeconds") {
    throw "run-lesson-verifier.ps1 must support TimeoutSeconds parameter."
}
if ($runnerScript -notmatch "scripts/verify-lesson-04-student\.ps1") {
    throw "run-lesson-verifier.ps1 Student mode must execute scripts/verify-lesson-04-student.ps1."
}

# 10. Skills Lock Assertions
$skillsLock = Get-Content "skills-lock.json" -Encoding UTF8 -Raw
if ($skillsLock -notmatch "bdf76c7c6b7b3b3e01bb15c9fdc42ac5351855c1") {
    throw "skills-lock.json must record exact 40-character upstream commit SHA for incremental-implementation."
}

$localSkillHash = (Get-FileHash ".claude\skills\incremental-implementation\SKILL.md" -Algorithm SHA256).Hash.ToLowerInvariant()
if ($skillsLock -notmatch $localSkillHash) {
    throw "skills-lock.json computedHash does not match actual local SKILL.md SHA256 ($localSkillHash)."
}

# 11. Student Export Script Whitelist Assertions
$exportScript = Get-Content "scripts\export-lesson-materials.ps1" -Encoding UTF8 -Raw
if ($exportScript -notmatch "LESSON_02_GUIDE\.md") {
    throw "export-lesson-materials.ps1 missing LESSON_02_GUIDE.md."
}
if ($exportScript -notmatch "LESSON_03_GUIDE\.md") {
    throw "export-lesson-materials.ps1 missing LESSON_03_GUIDE.md."
}
if ($exportScript -notmatch "grill-me") {
    throw "export-lesson-materials.ps1 missing grill-me."
}
if ($exportScript -notmatch "LESSON_04_GUIDE\.md") {
    throw "export-lesson-materials.ps1 missing LESSON_04_GUIDE.md."
}
if ($exportScript -notmatch "incremental-implementation") {
    throw "export-lesson-materials.ps1 missing incremental-implementation."
}
if ($exportScript -notmatch "verifier\.md") {
    throw "export-lesson-materials.ps1 missing verifier.md."
}
if ($exportScript -notmatch "run-lesson-verifier\.ps1") {
    throw "export-lesson-materials.ps1 missing run-lesson-verifier.ps1."
}
if ($exportScript -notmatch "verify-lesson-04-student\.ps1") {
    throw "export-lesson-materials.ps1 missing verify-lesson-04-student.ps1."
}

Write-Host "[PASS] Layered Contract Assertions across Roadmap & Execution Docs passed 100%."
Write-Host ""

Write-Host "[2/5] Checking protected design reference..."

$designReference = "references\original-design\DESIGN.md"
$expectedDesignHash = "CA4CAF27AC353EDB52C6459B23995107BF5FC5ECF1883E9A4999DE446892009B"

if (-not (Test-Path $designReference)) {
    throw "Protected design reference is missing."
}

$actualDesignHash = (
    Get-FileHash $designReference -Algorithm SHA256
).Hash

if ($actualDesignHash -ne $expectedDesignHash) {
    throw "Protected design reference hash has changed."
}

Write-Host "[PASS] Protected design reference is unchanged."
Write-Host ""

Write-Host "[3/5] Running TypeScript type check..."
& npm.cmd run typecheck

if ($LASTEXITCODE -ne 0) {
    throw "TypeScript type check failed."
}

Write-Host "[PASS] TypeScript type check passed."
Write-Host ""

Write-Host "[4/5] Running production build..."
& npm.cmd run build

if ($LASTEXITCODE -ne 0) {
    throw "Production build failed."
}

if (-not (Test-Path "dist\index.html")) {
    throw "Build finished but dist\index.html was not found."
}

Write-Host "[PASS] Production build passed."
Write-Host ""

Write-Host "[5/5] Checking prohibited environment files..."

$prohibitedFiles = @(
    ".env",
    ".env.local",
    ".env.development",
    ".env.production"
)

foreach ($file in $prohibitedFiles) {
    if (Test-Path $file) {
        throw "Prohibited environment file exists: $file"
    }
}

Write-Host "[PASS] No prohibited environment files were found."
Write-Host ""
Write-Host "========================================"
Write-Host "Verification completed successfully."
Write-Host "========================================"
