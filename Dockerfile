FROM alpine:3.21

WORKDIR /app

ARG TARGETOS
ARG TARGETARCH

COPY komari-agent-${TARGETOS}-${TARGETARCH} /app/komari-agent

RUN chmod +x /app/komari-agent \
    && touch /.komari-agent-container

# 设置环境变量
ENV KOMARI_SERVER="" \
    KOMARI_TOKEN=""

# 显示版本号，然后启动 komari-agent
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
