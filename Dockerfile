# Grafana recommends an alpine based image.
# Reference for updating the CA-certificates of an alpine image see https://stackoverflow.com/q/67231714

FROM grafana/grafana-oss:latest

# grafana has a custom user, to update the certificates we need higher privileges
USER root

# To be able to download `ca-certificates` with `apk add` command
COPY ${CERTIFICATE_FILE} /root/my-root-ca.crt
RUN cat /root/my-root-ca.crt >> /etc/ssl/certs/ca-certificates.crt

# Add again root CA with `update-ca-certificates` tool
RUN apk --no-cache add ca-certificates \
    && rm -rf /var/cache/apk/*
COPY ${CERTIFICATE_FILE} /usr/local/share/ca-certificates
RUN update-ca-certificates

RUN apk --no-cache add curl

# reset to custom user
USER 472
