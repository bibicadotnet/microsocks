FROM alpine:3.16 AS build

RUN apk --no-cache add make gcc musl-dev

COPY . /opt/microsocks
WORKDIR /opt/microsocks

RUN make clean && make

FROM alpine:3.16

COPY --from=build /opt/microsocks/microsocks /usr/local/bin/

RUN ls -lh /usr/local/bin/microsocks && \
    chmod +x /usr/local/bin/microsocks

ENTRYPOINT ["/usr/local/bin/microsocks"]
