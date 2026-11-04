FROM alpine:3.20
RUN apk add --no-cache ca-certificates curl unzip \
    && curl -L -o /tmp/Xray-linux-arm64-v8a.zip https://github.com/XTLS/Xray-core/releases/download/v26.10.21/Xray-linux-arm64-v8a.zip \
    && unzip /tmp/Xray-linux-arm64-v8a.zip -d /tmp/xray-dist \
    && install -m 755 /tmp/xray-dist/xray /usr/local/bin/xray \
    && rm -rf /tmp/Xray-linux-arm64-v8a.zip /tmp/xray-dist \
    && apk del curl unzip
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
