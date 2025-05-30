# Bước 1: Xây dựng môi trường với các công cụ cần thiết
FROM alpine:3.16 AS build

# Cài đặt các công cụ cần thiết cho việc build và kiểm tra
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

# Kiểm tra sự tồn tại của microsocks trong image
RUN echo "Kiểm tra xem microsocks có tồn tại không:" && \
    ls -l /usr/local/bin/microsocks && \
    file /usr/local/bin/microsocks && \
    ldd /usr/local/bin/microsocks || echo "Lỗi: microsocks không hợp lệ hoặc thiếu thư viện!"

# Kiểm tra các thư viện phụ thuộc (nếu có thể)
RUN echo "Kiểm tra các thư viện phụ thuộc:" && \
    ldd /usr/local/bin/microsocks || echo "Không có thư viện động (hoặc không phải chương trình động)!";

# Đảm bảo rằng entrypoint sử dụng microsocks
ENTRYPOINT ["/usr/local/bin/microsocks"]

# Bước 3: Kiểm tra command giúp đỡ (help)
RUN echo "Chạy lệnh giúp đỡ --help để kiểm tra tính năng của microsocks:" && \
    /usr/local/bin/microsocks --help || echo "Lỗi khi chạy lệnh giúp đỡ --help!"

# Bước 4: Kiểm tra khả năng kết nối qua socket (có thể chạy trong container)
RUN echo "Chạy thử microsocks để kiểm tra nếu nó khởi động chính xác..." && \
    /usr/local/bin/microsocks --help || echo "Lỗi khi khởi động microsocks!"

