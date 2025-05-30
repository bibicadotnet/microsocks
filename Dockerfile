FROM alpine:3.16 AS builder

# Cài dependencies build
RUN apk --no-cache add make gcc musl-dev

# Copy source code và build
COPY . /build
WORKDIR /build
RUN make clean && make && \
    mkdir -p /output && \
    cp microsocks /output/ && \
    ls -lh /output/microsocks  # Verify file exists

# Runtime image
FROM alpine:3.16

# Copy binary vào thư mục gốc (không dùng /usr/local/bin)
COPY --from=builder /output/microsocks /app/
RUN chmod +x /app/microsocks && \
    /app/microsocks -h  # Test ngay trong build

ENTRYPOINT ["/app/microsocks"]
