FROM quay.io/operator-framework/opm:latest as src
FROM alpine:latest

LABEL org.opencontainers.image.url="https://github.com/machine-node-linker/olm-actions"
LABEL org.opencontainers.image.author="https://github.com/machine-node-linker"

COPY --from=src /bin/opm /bin/opm
COPY entrypoint.sh /bin/
RUN apk add bash jq

ENTRYPOINT ["/bin/entrypoint.sh" ]

