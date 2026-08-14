$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot

Write-Host "========================================"
Write-Host "Student Package Verification"
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
    "START_HERE.md",
    "docs\LESSON_01_GUIDE.md",
    "docs\LESSON_02_GUIDE.md",
    "docs\LESSON_03_GUIDE.md",
    "docs\LESSON_04_GUIDE.md",
    "docs\LESSON_05_GUIDE.md",
    "docs\LESSON_06_GUIDE.md",
    "docs\LESSON_07_GUIDE.md",
    "docs\LESSON_08_GUIDE.md",
    "docs\LESSON_09_GUIDE.md",
    "docs\LESSON_10_GUIDE.md",
    "docs\COURSE_ROADMAP.md",
    "lessons\html\0001-ai-agent-architecture-and-first-prototype.html",
    "lessons\html\0002-visual-refactoring-and-design-harness.html",
    "lessons\html\0003-requirements-clarification-and-data-contract.html",
    "lessons\html\0004-controlled-agent-loop-and-disk-persistence.html",
    "lessons\html\0005-engineering-harness-and-memory-model.html",
    "lessons\html\0006-facts-anchored-debugging-and-bounded-loop.html",
    "lessons\html\0007-browser-mcp-and-four-evidence-chains.html",
    "lessons\html\0008-codex-independent-review-and-context-isolation.html",
    "lessons\html\0009-ai-opportunity-map-and-agent-pattern-selection.html",
    "lessons\html\0010-prototype-freeze-and-product-decision-package.html",
    "lessons\html\COURSE_ROADMAP.html",
    "lessons\html\GLOSSARY.html",
    ".claude\skills\diagnose\SKILL.md",
    ".claude\skills\grill-me\SKILL.md",
    ".claude\skills\incremental-implementation\SKILL.md",
    ".claude\agents\qa-tester.md",
    "src\main.ts",
    "src\App.vue",
    "src\router\index.ts",
    "scripts\verify-student-project.ps1",
    "VERSION.txt",
    "PACKAGE_MANIFEST.txt",
    "SHA256SUMS.txt"
)



foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        throw "Required file is missing: $file"
    }
}

if (-not (Test-Path "node_modules")) {
    throw "node_modules is missing. Run npm ci or npm install first."
}

Write-Host "[PASS] Required files are present."
Write-Host ""

Write-Host "[2/5] Checking prohibited teacher-only paths..."

# Note: .git is intentionally NOT prohibited. The distributed ZIP has no Git
# history, but learners may initialize their own independent repository later.
$prohibitedPaths = @(
    "references",
    "CONTRIBUTING.md",
    "lessons\COURSE_ROADMAP.md",
    "lessons\TEN_LESSON_FROZEN_BASELINE.md",
    "lessons\LESSON_01_TEACHER_PLAN.md",
    "lessons\LESSON_02_TEACHER_PLAN.md",
    "lessons\LESSON_03_TEACHER_PLAN.md",
    "lessons\LESSON_04_TEACHER_PLAN.md",
    "lessons\LESSON_05_TEACHER_PLAN.md",
    "lessons\LESSON_06_TEACHER_PLAN.md",
    "lessons\LESSON_07_TEACHER_PLAN.md",
    "lessons\LESSON_08_TEACHER_PLAN.md",
    "lessons\LESSON_09_TEACHER_PLAN.md",
    "lessons\LESSON_10_TEACHER_PLAN.md",
    "lessons\DESIGN_SPECIFICATION.md",
    "docs\DESIGN_ALIGNMENT_AUDIT.md",
    "docs\DESIGN_ALIGNMENT_DECISIONS.md",
    "docs\DESIGN_ALIGNMENT_FINAL_REPORT.md",
    "docs\主管 AI 原型制作训练营.md",
    "scripts\verify-project.ps1", # legacy
    "scripts\export-student-package.ps1",
    "scripts\export-lesson-materials.ps1",
    "scripts\install-lesson-materials.ps1",
    "student-package",
    ".agents",
    ".github"
)

foreach ($pathItem in $prohibitedPaths) {
    if (Test-Path $pathItem) {
        throw "Prohibited path exists in student package: $pathItem"
    }
}

Write-Host "[PASS] No prohibited teacher-only paths found."
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

Write-Host "[5/5] Checking prohibited environment and credential files (recursive)..."

$allFiles = Get-ChildItem -LiteralPath $projectRoot -Recurse -File -Force -ErrorAction SilentlyContinue
foreach ($file in $allFiles) {
    # Skip generated/dependency trees for speed and noise
    $full = $file.FullName
    if ($full -match '[\\/]node_modules[\\/]' -or $full -match '[\\/]dist[\\/]' -or $full -match '[\\/]\.git[\\/]') {
        continue
    }

    $name = $file.Name
    $rel = $full.Substring($projectRoot.Length).TrimStart('\', '/')

    if ($name -eq ".env.example") {
        continue
    }

    if ($name -eq ".env" -or $name -like ".env.*") {
        throw "Prohibited environment file exists: $rel"
    }

    if ($name -like "*.pem" -or $name -like "*.key" -or $name -like "*.pfx" -or $name -like "*.p12" -or $name -eq "id_rsa") {
        throw "Prohibited credential file exists: $rel"
    }
}

Write-Host "[PASS] No prohibited environment or credential files were found."
Write-Host ""
Write-Host "========================================"
Write-Host "Student project verification completed successfully."
Write-Host "========================================"
