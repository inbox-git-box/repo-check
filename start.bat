@echo off
REM Scrumora - Start all services without Docker (Windows)
REM Usage: start.bat

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "ROOT_DIR=%SCRIPT_DIR%"

goto main

:log
    setlocal
    set "color=%1"
    set "prefix=%2"
    set "message=%3"
    echo %color%%prefix% %message%
    endlocal
    exit /b

:banner
    cls
    echo.
    echo ===============================================================
    echo   Scrumora - Project Management Tool
    echo ===============================================================
    echo.
    exit /b

:check_requirements
    echo 🔍 Checking prerequisites...
    echo.

    REM Check Node.js
    node --version >nul 2>&1
    if errorlevel 1 (
        echo ✗ Node.js is not installed!
        echo Install from: https://nodejs.org
        exit /b 1
    )
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo ✓ Node.js !NODE_VERSION! detected

    REM Check npm
    npm --version >nul 2>&1
    if errorlevel 1 (
        echo ✗ npm is not installed!
        exit /b 1
    )
    for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
    echo ✓ npm !NPM_VERSION! detected

    REM Check .env file
    if not exist "%ROOT_DIR%.env" (
        echo ⚠ .env file not found
        echo ⚠ Using defaults from docker-compose.yml
    ) else (
        echo ✓ .env file found
    )

    REM Check MongoDB
    mongosh --version >nul 2>&1
    if not errorlevel 1 (
        echo ✓ MongoDB CLI tools found
    ) else (
        mongo --version >nul 2>&1
        if errorlevel 1 (
            echo ⚠ MongoDB CLI tools not found (optional)
        ) else (
            echo ✓ MongoDB CLI tools found
        )
    )

    echo ⚠ MongoDB must be running on localhost:27017
    echo ⚠ Start MongoDB with: mongod.exe
    echo.
    exit /b

:install_dependencies
    echo 📦 Installing dependencies...
    echo.

    if not exist "%ROOT_DIR%node_modules" (
        cd /d "%ROOT_DIR%"
        call npm install
    )

    if not exist "%ROOT_DIR%scrumora-api\node_modules" (
        cd /d "%ROOT_DIR%scrumora-api"
        call npm install
    )

    if not exist "%ROOT_DIR%scrumora-fe\node_modules" (
        cd /d "%ROOT_DIR%scrumora-fe"
        call npm install
    )

    echo ✓ Dependencies installed
    echo.
    exit /b

:start_services
    echo 🚀 Starting Scrumora services...
    echo.

    echo ○ Starting Backend API...
    cd /d "%ROOT_DIR%scrumora-api"
    start "Scrumora Backend" cmd /k "npm run dev"

    echo ○ Starting Frontend...
    cd /d "%ROOT_DIR%scrumora-fe"
    start "Scrumora Frontend" cmd /k "npm run dev"

    echo.
    echo ✓ All services started!
    echo.
    echo 📍 Frontend:  http://localhost:3000
    echo 📍 Backend:   http://localhost:5001
    echo 📍 MongoDB:   localhost:27017
    echo.
    echo 💡 Tip: Close the terminal windows to stop services
    echo.

    REM Keep main window open
    pause
    exit /b

:main
    call :banner
    call :check_requirements
    if errorlevel 1 exit /b 1
    call :install_dependencies
    call :start_services
    exit /b
