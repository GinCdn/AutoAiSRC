#!/bin/sh
# AiSRC 容器入口：首次启动自动生成配置，无需手动 cp config.example.yaml
set -e

CONF_HOST="/app/data/config.yaml"

mkdir -p /app/data /app/logs /app/work

if [ ! -f "$CONF_HOST" ]; then
  cp /app/config.example.yaml "$CONF_HOST"
  # 数据库地址自动指向 compose 服务名 mysql
  sed -i 's/host: "127.0.0.1"/host: "mysql"/' "$CONF_HOST"
  echo "[entrypoint] 已自动生成配置 /app/data/config.yaml（mysql.host 已指向 mysql 服务）"
  echo "[entrypoint] 如需自定义（登录密码/LLM 等），编辑宿主机 ./data/config.yaml 后重启容器即可"
fi

# 每次启动以宿主机挂载的配置为准（宿主机 ./data/config.yaml 持久化）
cp "$CONF_HOST" /app/config.yaml

exec ./aisrc
