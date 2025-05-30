FROM alpine:3.16 AS builder

# Cài dependencies tối thiểu (bỏ linux-headers)
RUN apk --no-cache add make gcc musl-dev

# Copy source code local
COPY . /opt/microsocks
WORKDIR /opt/microsocks

# Build và strip binary
RUN make clean && \
    make && \
    strip microsocks && \
    mkdir -p /output && \
    mv microsocks /output/

# Runtime image
FROM alpine:3.16

# Copy binary và set permission
COPY --from=builder /output/microsocks /usr/local/bin/
RUN chmod +x /usr/local/bin/microsocks

ENTRYPOINT ["/usr/local/bin/microsocks"]
