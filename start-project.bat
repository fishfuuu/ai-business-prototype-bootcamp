@echo off
setlocal

cd /d "%~dp0"

echo ========================================
echo AI Business Prototype Starter
echo ========================================
echo.

where node >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Node.js was not found.
  echo Please install Node.js 20.19.0 or later.
  pause
  exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
  echo [ERROR] npm was not found.
  pause
  exit /b 1
)

if not exist "package.json" (
  echo [ERROR] package.json was not found.
  echo Current directory: %CD%
  pause
  exit /b 1
)

if not exist "node_modules" (
  echo [ERROR] Dependencies are not installed.
  echo.
  echo Run:
  echo   npm install
  echo.
  pause
  exit /b 1
)

echo [INFO] Project directory: %CD%
echo [INFO] Starting development server...
echo [INFO] Address: http://127.0.0.1:8888
echo.
echo Press Ctrl+C to stop the server.
echo.

call npm run dev

if errorlevel 1 (
  echo.
  echo [ERROR] The development server stopped with an error.
  pause
  exit /b 1
)

endlocal
