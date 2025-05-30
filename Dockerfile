# Bước 1: Build microsocks
FROM alpine:3.16 AS build

# Cài đặt các công cụ cần thiết để biên dịch
RUN apk --no-cache add make gcc linux-headers git musl-dev musl-gcc

# Cloning microsocks repo
RUN git clone https://github.com/rofl0r/microsocks /opt/microsocks
WORKDIR /opt/microsocks

# Kiểm tra xem musl-gcc có tồn tại không
RUN which musl-gcc || echo "musl-gcc not found"

# Biên dịch với musl-gcc
RUN CC=musl-gcc make V=1

# Bước 2: Tạo image cuối cùng
FROM alpine:3.16

# Ghi chú người bảo trì
LABEL MAINTAINER=heywoodlh

# Sao chép microsocks đã biên dịch từ bước trước
COPY --from=build /opt/microsocks/microsocks /usr/local/bin/microsocks

# Kiểm tra lại microsocks có tồn tại không và có quyền thực thi
RUN ls -l /usr/local/bin/ && chmod +x /usr/local/bin/microsocks

# Cài đặt quyền cho microsocks
ENTRYPOINT ["/usr/local/bin/microsocks"]
