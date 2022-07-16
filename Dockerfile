FROM quay.io/operator-framework/opm:latest as src
FROM alpine:latest

LABEL org.opencontainers.image.url="https://github.com/machine-node-linker/olm-actions"

COPY --from=src /bin/opm /bin/opm
COPY entrypoint.sh /bin/
ENTRYPOINT ["/bin/entrypoint.sh" ]

