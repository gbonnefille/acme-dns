FROM golang:1.13-alpine AS builder

ARG ACME_DNS_VERSION=v0.8
ENV CGO_ENABLED=1

WORKDIR /build

RUN apk add -U --no-cache ca-certificates git gcc musl-dev

COPY . .

RUN go build


FROM scratch

COPY --from=builder /build/acme-dns /
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 53/udp 53 80 443
ENTRYPOINT ["/acme-dns"]
VOLUME ["/etc/acme-dns", "/var/lib/acme-dns"]
