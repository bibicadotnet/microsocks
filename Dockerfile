FROM alpine:3.18 AS build

RUN apk add --no-cache make gcc musl-dev linux-headers xz wget

WORKDIR /opt

RUN wget http://ftp.barfooze.de/pub/sabotage/tarballs/microsocks-1.0.5.tar.xz \
    && tar xf microsocks-1.0.5.tar.xz

WORKDIR /opt/microsocks-1.0.5

RUN make clean && make CFLAGS='-O2 -static' && strip microsocks

FROM alpine:3.18

COPY --from=build /opt/microsocks-1.0.5/microsocks /usr/local/bin/microsocks

ENTRYPOINT ["/usr/local/bin/microsocks"]
