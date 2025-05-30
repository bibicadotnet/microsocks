# Stage 1: Build static binary
FROM alpine:3.18 AS build

RUN apk add --no-cache make gcc musl-dev linux-headers git

RUN git clone https://github.com/rofl0r/microsocks /opt/microsocks
WORKDIR /opt/microsocks

# Build static binary, giảm dung lượng bằng strip
RUN make clean && make CFLAGS='-O2 -static' && strip microsocks

# Stage 2: Final image
FROM alpine:3.18


COPY --from=build /opt/microsocks/microsocks /usr/local/bin/microsocks

ENTRYPOINT ["/usr/local/bin/microsocks"]
