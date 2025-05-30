# Bước 1: Xây dựng môi trường với các công cụ cần thiết
FROM alpine:3.16 AS build

RUN apk --no-cache add make gcc linux-headers git musl-dev musl-utils

# Clone và build microsocks từ GitHub
RUN git clone https://github.com/rofl0r/microsocks /opt/microsocks
WORKDIR /opt/microsocks

# Biên dịch microsocks với các thư viện tĩnh (static linking)
RUN make CFLAGS="-O2 -static" && strip microsocks

# Bước 2: Tạo image sản phẩm cuối cùng
FROM alpine:3.16
LABEL MAINTAINER=heywoodlh

# Copy file microsocks vào thư mục /usr/local/bin trong container
COPY --from=build /opt/microsocks/microsocks /usr/local/bin/microsocks

# Đảm bảo rằng entrypoint sử dụng microsocks
ENTRYPOINT ["/usr/local/bin/microsocks"]
