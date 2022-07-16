FROM quay.io/operator-framework/opm:latest as src
FROM alpine:latest

COPY --from=src /bin/opm /bin/opm
COPY entrypoint.sh /bin/
ENTRYPOINT ["/bin/entrypoint.sh" ]

