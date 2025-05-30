FROM alpine:3.16 AS build

RUN apk --no-cache add make gcc linux-headers git musl-dev

RUN git clone https://github.com/rofl0r/microsocks /opt/microsocks
WORKDIR /opt/microsocks

RUN make

FROM alpine:3.16
LABEL MAINTAINER=heywoodlh

# Create the directory first and ensure correct permissions
RUN mkdir -p /usr/local/bin && chmod -R 755 /usr/local/bin

# Copy the binary from build stage
COPY --from=build /opt/microsocks/microsocks /usr/local/bin/microsocks

# Verify the binary exists and is executable
RUN ls -la /usr/local/bin && \
    [ -f /usr/local/bin/microsocks ] && \
    chmod +x /usr/local/bin/microsocks

ENTRYPOINT ["/usr/local/bin/microsocks"]
