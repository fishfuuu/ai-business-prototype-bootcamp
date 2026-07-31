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
    "docs\COMPONENT_CATALOG.md",
    "docs\LESSON_01_GUIDE.md",
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

Write-Host "[PASS] Required files are present."
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
