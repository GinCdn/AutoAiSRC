# AiSRC 服务端镜像（静态编译，无 CGO 依赖）
FROM alpine:3.20

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

COPY aisrc ./aisrc
COPY web ./web
COPY config.example.yaml ./config.example.yaml

RUN chmod +x ./aisrc && mkdir -p data logs work

EXPOSE 8080

# 配置通过挂载提供：-v /path/config.yaml:/app/config.yaml
ENTRYPOINT ["./aisrc"]
