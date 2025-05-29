FROM alpine:3.16 AS builder

RUN apk --no-cache --update add make gcc musl-dev

COPY . /opt/microsocks

WORKDIR /opt/microsocks

RUN make clean && make && strip microsocks

FROM busybox:musl

COPY --from=builder /opt/microsocks/microsocks /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/microsocks"]
