FROM alpine:3.18 AS build

RUN apk add --no-cache make gcc musl-dev linux-headers
WORKDIR /app
COPY . .

RUN make clean && make CFLAGS='-O2 -static' && strip microsocks

FROM alpine:3.18

COPY --from=build /app/microsocks /usr/local/bin/microsocks
ENTRYPOINT ["/usr/local/bin/microsocks"]
