FROM alpine:3.16 AS builder

RUN apk --no-cache add \
    make \
    gcc \
    musl-dev  # Thư viện C cực nhẹ

COPY . /opt/microsocks

WORKDIR /opt/microsocks

RUN make clean && make && \
    strip microsocks

FROM alpine:3.16

COPY --from=builder /opt/microsocks/microsocks /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/microsocks"]
