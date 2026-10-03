#!/usr/bin/env bash
# AiSRC Linux 启动脚本
set -e
cd "$(dirname "$0")"

if [ ! -f config.yaml ]; then
    echo "[start] 缺少 config.yaml，请从发行包补齐后再启动"
    exit 1
fi

chmod +x ./aisrc
exec ./aisrc
