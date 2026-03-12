@echo off
setlocal enabledelayedexpansion
cd /d %~dp0

echo ==============================================
echo    OpenAlgo Chart - Interactive Launcher
echo ==============================================

:: --- Step 1: Check for Node.js in common locations if not in PATH ---
echo.
echo [1/3] Checking environment...

:: Try to find node in the current PATH first
where node >nul 2>&1
if !errorlevel! neq 0 (
    echo Node.js not found in system PATH. Checking common locations...
    
    :: Define common Node.js install paths
    set "NODE_PATHS=C:\Program Files\nodejs;C:\Program Files (x86)\nodejs;%AppData%\npm;%USERPROFILE%\AppData\Local\nvm\default"
    
    for %%p in (!NODE_PATHS!) do (
        if exist "%%p\node.exe" (
            echo Found Node.js in %%p
            set "PATH=%%p;!PATH!"
            goto :node_found
        )
    )
    
    echo [ERROR] Node.js is not installed or not in your PATH.
    echo Please install Node.js (Version 20+^) from https://nodejs.org/
    pause
    exit /b 1
)

:node_found
echo Node.js version is:
node -v
echo npm version is:
call npm -v

:: --- Step 2: Verification of Files ---
if not exist package.json (
    echo [ERROR] package.json not found in current folder: !CD!
    echo Please ensure this .bat file is in the root of the openalgo-chart folder.
    pause
    exit /b 1
)

:: --- Step 3: Install Dependencies ---
if not exist node_modules (
    echo.
    echo [2/3] node_modules not found. Starting installation...
    echo This may take a few minutes depending on your internet connection.
    call npm install
    if !errorlevel! neq 0 (
        echo.
        echo [ERROR] npm install failed. 
        echo Check the output above for more information.
        pause
        exit /b !errorlevel!
    )
    echo Installation complete.
) else (
    echo [2/3] Dependencies already installed.
)

:: --- Step 4: Launch ---
echo.
echo [3/3] Starting the application...
echo ----------------------------------------------
echo App will be available at: http://localhost:5001
echo ----------------------------------------------
echo.
call npm run dev

if !errorlevel! neq 0 (
    echo.
    echo [ERROR] The application failed to start or was stopped with an error.
)

pause

