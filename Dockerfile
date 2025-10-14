FROM alpine:3.21

WORKDIR /app

# Docker buildx 会在构建时自动填充这些变量
ARG TARGETOS
ARG TARGETARCH

COPY komari-agent-${TARGETOS}-${TARGETARCH} /app/komari-agent

RUN chmod +x /app/komari-agent \
    && touch /.komari-agent-container

# 设置环境变量（可在 docker-compose 或 docker run -e 覆盖）
ENV KOMARI_SERVER="" \
    KOMARI_TOKEN=""

# 使用 shell 脚本读取环境变量并传给 komari-agent
ENTRYPOINT ["/bin/sh", "-c", "\
    if [ -z \"$KOMARI_SERVER\" ] || [ -z \"$KOMARI_TOKEN\" ]; then \
        echo 'Error: KOMARI_SERVER or KOMARI_TOKEN not set'; \
        exit 1; \
    fi; \
    exec /app/komari-agent -e \"$KOMARI_SERVER\" -t \"$KOMARI_TOKEN\" \
"]

# 默认 CMD（可以省略）
CMD ["--help"]
