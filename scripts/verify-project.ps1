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
    "docs/assets/lesson-01/lesson-01-flow.png",
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

# Verify Teacher Plan 22-section structure
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
if ($manuscript -notmatch [regex]::Escape("COURSE_ROADMAP.md")) {
    throw "Manuscript is missing reference to authoritative COURSE_ROADMAP.md"
}

# 3. PROJECT_STATE.md Contract Assertions (Must default to '待开始', unchecked checkboxes, no '.env.local' conflict)
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

# 4. Lesson 01 Layered Assertions (Work Memory, Tools sandboxing, HITL)
$l1Guide = Get-Content "docs\LESSON_01_GUIDE.md" -Encoding UTF8 -Raw
if ($l1Guide -notmatch [regex]::Escape("PROJECT_STATE.md")) {
    throw "LESSON_01_GUIDE.md missing PROJECT_STATE.md step."
}
if ($l1Guide -notmatch [regex]::Escape("Tools 权限沙箱")) {
    throw "LESSON_01_GUIDE.md missing Tools permission sandboxing explanation."
}

# 5. Lesson 02 Layered Assertions (Visual Harness, safe Git, no 'commit -am', no 'git checkout .')
$l2Guide = Get-Content "docs\LESSON_02_GUIDE.md" -Encoding UTF8 -Raw
if ($l2Guide -match [regex]::Escape("commit -am")) {
    throw "LESSON_02_GUIDE.md contains dangerous 'commit -am' command."
}
if ($l2Guide -match [regex]::Escape("git checkout .")) {
    throw "LESSON_02_GUIDE.md contains dangerous 'git checkout .' command."
}
if ($l2Guide -notmatch [regex]::Escape("Discard Changes")) {
    throw "LESSON_02_GUIDE.md missing Discard Changes UI instructions."
}

# 6. Lesson 03 Layered Assertions (grill-me Skill, Data Contract, 4 Elements)
$l3Guide = Get-Content "docs\LESSON_03_GUIDE.md" -Encoding UTF8 -Raw
if ($l3Guide -notmatch [regex]::Escape("grill-me")) {
    throw "LESSON_03_GUIDE.md missing grill-me Skill reference."
}
if ($l3Guide -notmatch [regex]::Escape("数据契约")) {
    throw "LESSON_03_GUIDE.md missing Data Contract reference."
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
