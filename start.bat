@echo off
rem AiSRC Windows 启动脚本
cd /d "%~dp0"

if not exist config.yaml (
    echo [start] 缺少 config.yaml，请从发行包补齐后再启动
    pause
    exit /b 1
)

aisrc.exe
pause
