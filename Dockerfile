# Stage 1: Build với Alpine (như bản gốc)
FROM alpine:3.18 AS builder

RUN apk --no-cache add make gcc linux-headers git musl-dev && \
    git clone https://github.com/rofl0r/microsocks /opt/microsocks && \
    cd /opt/microsocks && \
    make LDFLAGS="-static"  # Biên dịch thành static binary

# Stage 2: Image cuối - chỉ chứa file binary
FROM scratch

COPY --from=builder /opt/microsocks/microsocks /microsocks

ENTRYPOINT ["/microsocks"]
