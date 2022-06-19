# build stage
FROM golang:alpine AS build-env

WORKDIR /workspace

COPY go.* main.go ./

RUN env CGO_ENABLED=0 go build -trimpath -ldflags '-w' -o tcp-proxy .

# image stage
FROM alpine

LABEL org.opencontainers.image.source https://github.com/keecon/docker-images

COPY --from=build-env /workspace/tcp-proxy /bin/tcp-proxy

CMD ["tcp-proxy"]
