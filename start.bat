@echo off
rem AiSRC Windows launcher
cd /d "%~dp0"

if not exist config.yaml (
    echo [start] config.yaml not found. Please restore it from the release package.
    pause
    exit /b 1
)

aisrc.exe
pause
