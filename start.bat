@echo off
title Janitor-proxy-gemini (PC Local Server)
cd /d "%~dp0"
cls

echo ===================================================================
echo   Janitor-proxy-gemini - PC Launcher
echo ===================================================================
echo [1/2] Checking Python and dependencies...

python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in your PATH.
    echo Please install Python from https://www.python.org/ or the Microsoft Store.
    echo Make sure to check "Add Python to PATH" during installation!
    pause
    exit /b 1
)

python -m pip install httpx >nul 2>&1
echo [2/2] Dependencies ready!
echo.

cls
echo ===================================================================
echo             SERVER IS LIVE AND READY TO ROLEPLAY
echo ===================================================================
echo  1. Open JanitorAI in your browser (Chrome/Edge/Firefox)
echo  2. Go to: API Settings - Proxy
echo  3. Set:
echo     - Proxy URL:  http://127.0.0.1:8081/v1
echo     - API Key:    sk-gemini
echo     - Model:      gemini-3.8-flash-thinking (Default)
echo                   (or gemini-3.8-flash / gemini-3.1-pro)
echo ===================================================================
echo  Running 100%% locally on your PC (Zero lag / No Cloudflare needed)
echo  Press Ctrl+C in this window to stop the server.
echo  Start anytime with command: insom
echo ===================================================================
echo.
echo [Live Logs - Chat requests will appear below]:

python gemini_web2api.py --port 8081
pause
