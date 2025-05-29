FROM alpine:3.16 AS builder

RUN apk --no-cache --update add make gcc linux-headers musl-dev && \
    cp -r . /build && cd /build && \
    make clean && make && \
    strip /build/microsocks

FROM alpine:3.16

COPY --from=builder /build/microsocks /usr/local/bin/

RUN adduser -D -H -s /bin/false socksuser && \
    chmod +x /usr/local/bin/microsocks

USER socksuser

ENTRYPOINT ["/usr/local/bin/microsocks"]
