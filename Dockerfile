FROM alpine:3.16 AS build

# Cài đặt các gói cần thiết
RUN apk --no-cache add make gcc linux-headers git musl-dev

# Clone repo
RUN git clone https://github.com/rofl0r/microsocks.git  /opt/microsocks
WORKDIR /opt/microsocks

# Kiểm tra nội dung thư mục
RUN ls -la

# Kiểm tra musl-gcc
RUN which musl-gcc || true

# Compile với verbose mode để debug
RUN CC=musl-gcc make V=1

# Final image
FROM alpine:3.16
LABEL MAINTAINER=heywoodlh

COPY --from=build /opt/microsocks/microsocks /usr/local/bin/microsocks

ENTRYPOINT ["/usr/local/bin/microsocks"]
