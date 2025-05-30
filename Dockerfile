# Stage 1: Optimized build
FROM alpine:3.18 AS builder

RUN apk --no-cache add make gcc linux-headers git musl-dev && \
    git clone --depth 1 https://github.com/rofl0r/microsocks /opt/microsocks && \
    cd /opt/microsocks && \
    make CFLAGS="-Os -pipe -static" LDFLAGS="-static -s" && \
    strip --strip-all microsocks && \
    apk del --purge make gcc linux-headers git musl-dev && \
    rm -rf /var/cache/apk/* /opt/microsocks/.git

# Stage 2: Minimal runtime
FROM alpine:3.18

COPY --from=builder /opt/microsocks/microsocks /usr/local/bin/
RUN chmod +x /usr/local/bin/microsocks

ENTRYPOINT ["/usr/local/bin/microsocks"]
