#!/usr/bin/env bash
# AiSRC Linux 启动脚本
set -e
cd "$(dirname "$0")"

if [ ! -f config.yaml ]; then
    cp config.example.yaml config.yaml
    echo "[start] 已从模板生成 config.yaml，请先编辑数据库与登录配置后再启动"
    exit 1
fi

chmod +x ./aisrc
exec ./aisrc
