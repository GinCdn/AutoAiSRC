@echo off
rem AiSRC Windows 启动脚本
cd /d "%~dp0"

if not exist config.yaml (
    copy config.example.yaml config.yaml >nul
    echo [start] 已从模板生成 config.yaml，请先编辑数据库与登录配置后再启动
    pause
    exit /b 1
)

aisrc.exe
pause
