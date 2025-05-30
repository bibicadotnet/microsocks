# Bước 1: Build microsocks
FROM alpine:3.18 AS build

# Cài đặt các công cụ cần thiết để biên dịch
RUN apk --no-cache add make gcc linux-headers git musl-dev

# Cloning microsocks repo
RUN git clone https://github.com/rofl0r/microsocks /opt/microsocks
WORKDIR /opt/microsocks

# Biên dịch với các flags tối ưu
RUN make CFLAGS="-O2 -pipe"

# Bước 2: Tạo image cuối cùng
FROM alpine:3.18

# Ghi chú người bảo trì
LABEL MAINTAINER=heywoodlh

# Sao chép microsocks đã biên dịch
COPY --from=build /opt/microsocks/microsocks /usr/local/bin/

# Kiểm tra và cấp quyền thực thi
RUN ls -l /usr/local/bin/microsocks && \
    chmod +x /usr/local/bin/microsocks && \
    ldd /usr/local/bin/microsocks || true

# Cài đặt entrypoint
ENTRYPOINT ["/usr/local/bin/microsocks"]
