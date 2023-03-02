# Proof of Concept for a Monitoring Application Stack

## Custom Grafana image

For a setup behind a company proxy grafana requires additional certificates.

**Requirements:**

- a certificate (.crt/.pem)  or a certificate bundle (.pem)
- build the custom image by providing the certificate as build argument:

> **Warning**
>
> Uploading a custom image to a public registry exposes your private certificates!

```bash
docker build . -t <image-name>:<tag> --build-arg CERTIFICATE_FILE=<path-to-certificate>
```

e.g.

```bash
docker build . -t grafana-custom --build-arg CERTIFICATE_FILE=certificate-bundle.pem
```

## Start a root terminal session with a running container

```bash
docker compose exec -it -u 0 <service-name> bash
```

e.g.

```bash
docker compose exec -it -u 0 grafana bash
```