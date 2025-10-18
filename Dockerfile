FROM alpine:3.21

WORKDIR /app

ARG TARGETOS=linux
ARG TARGETARCH=amd64

# 在构建时自动下载最新的 komari-agent
RUN apk add --no-cache curl && \
    curl -L -o /app/komari-agent \
    https://github.com/vinceluv88/komari-agent/releases/latest/download/komari-agent-${TARGETOS}-${TARGETARCH} && \
    chmod +x /app/komari-agent && \
    touch /.komari-agent-container

# 设置环境变量
ENV KOMARI_SERVER="" \
    KOMARI_TOKEN=""

# 启动命令
ENTRYPOINT ["/bin/sh", "-c", "\
    echo 'Komari Agent help:'; \
    /app/komari-agent --help; \
    if [ -z \"$KOMARI_SERVER\" ] || [ -z \"$KOMARI_TOKEN\" ]; then \
        echo 'Error: KOMARI_SERVER or KOMARI_TOKEN not set'; \
        exit 1; \
    fi; \
    exec /app/komari-agent -e \"$KOMARI_SERVER\" -t \"$KOMARI_TOKEN\" \
"]

CMD []
