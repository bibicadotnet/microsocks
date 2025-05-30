# Stage 1: Build static binary
FROM alpine:3.18 AS builder

RUN apk --no-cache add make gcc linux-headers git musl-dev && \
    git clone --depth 1 https://github.com/rofl0r/microsocks /opt/microsocks && \
    cd /opt/microsocks && \
    make LDFLAGS="-static" CFLAGS="-Os -pipe" && \
    strip --strip-all microsocks

# Stage 2: Ultra-light runtime
FROM scratch

COPY --from=builder /opt/microsocks/microsocks /microsocks

ENTRYPOINT ["/microsocks"]
