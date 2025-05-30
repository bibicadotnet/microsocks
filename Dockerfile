# Bước 1: Build microsocks - Tối ưu hóa build stage
FROM alpine:3.18 AS build

# Gộp các lệnh RUN để giảm layer và dọn dẹp cache ngay sau khi cài đặt
RUN apk --no-cache add make gcc linux-headers git musl-dev && \
    git clone https://github.com/rofl0r/microsocks /opt/microsocks && \
    cd /opt/microsocks && \
    make CFLAGS="-Os -pipe" && \
    strip --strip-all microsocks && \
    apk del make gcc linux-headers git musl-dev

# Bước 2: Tạo image cuối cùng - Giữ nguyên cấu trúc nhưng tối ưu size
FROM alpine:3.18

# Sao chép binary đã được tối ưu
COPY --from=build /opt/microsocks/microsocks /usr/local/bin/

# Gộp các lệnh kiểm tra và cấp quyền
RUN chmod +x /usr/local/bin/microsocks && \
    [ -f /usr/local/bin/microsocks ] && \
    du -h /usr/local/bin/microsocks

# Cài đặt entrypoint
ENTRYPOINT ["/usr/local/bin/microsocks"]
