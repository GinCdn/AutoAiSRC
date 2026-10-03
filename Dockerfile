# AiSRC 服务端镜像（静态编译，无 CGO 依赖）
FROM alpine:3.20

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

COPY aisrc ./aisrc
COPY web ./web
COPY config.example.yaml ./config.example.yaml
COPY docker-entrypoint.sh ./docker-entrypoint.sh

# 兼容 Windows 解压可能带入的 CRLF 行尾
RUN sed -i 's/\r$//' ./docker-entrypoint.sh \
  && chmod +x ./aisrc ./docker-entrypoint.sh \
  && mkdir -p data logs work

EXPOSE 8080

# 首次启动自动生成 /app/data/config.yaml（宿主机 ./data 挂载持久化）
ENTRYPOINT ["./docker-entrypoint.sh"]
