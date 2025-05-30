FROM alpine:latest as builder
ARG MICROSOCKS_TAG=v1.0.5
ENV MICROSOCKS_URL="https://github.com/rofl0r/microsocks/archive/refs/tags/$MICROSOCKS_TAG.zip"
WORKDIR /build
ADD $MICROSOCKS_URL .
RUN apk add --update --no-cache \
      build-base unzip && \
      unzip $MICROSOCKS_TAG.zip && \
      cd microsocks-${MICROSOCKS_TAG:1} && \
      make && \
      cp ./microsocks ..

FROM alpine
WORKDIR /app
COPY --from=builder /build/microsocks .
RUN apk add --update --no-cache \
      coreutils shadow tzdata && \
      chmod +x ./microsocks
ENTRYPOINT [ "/app/microsocks" ]
