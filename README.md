# Monitoring stack

This proof of concept aims to analyze the options and requirements to monitor distributed applications and their interfaces. Utilizing the open-source observability stack of [Grafana Labs](https://grafana.com/) and other vendors a layered container stack is implemented.

> **Warning**
>
> This is a **proof of concept** and far from a production ready setup! Please visit the respective documentation of each component for a secure and reliable deployment.

## The setup

### Prerequisites

- Docker
- Docker compose v2
- [Grafana Loki's Docker plugin](https://grafana.com/docs/loki/latest/clients/docker-driver/#docker-driver-client)
- this repository

### Components

- [Loki](https://grafana.com/oss/loki/) - a Log aggregation system
- [Prometheus](https://prometheus.io) - a systems monitoring and alerting toolkit
- [Grafana](https://grafana.com/grafana/) - a visualization and observability platform
- [MinIO](https://min.io/) - s3 compatible object storage
- [cAdvisor](https://github.com/google/cadvisor) - resource and performance characteristics of running containers

### Architecture

The applications are separated into three layers:

1. infrastructure
    - Storage
    - Log aggregation
2. metrics
    - Metric/log collection
3. observability
    - Visualization
    - TimeSeries Database (for custom metrics)

Both layers have their own compose files, but share the same bridge network `monitoring-network`. To pass configuration files, some components have their own directory, containing a config file.

```tree
.
├── loki
│   └── loki-config.yml
├── prometheus
│   └── prometheus-config.yml
├── compose-infra.yml
├── compose-observe.yml
.
```

---

## The Logging Stack

To aggregate the logs of our monitoring stack we use Grafana's Loki. The initial configuration was inspired [by](https://docs.technotim.live/posts/grafana-loki/).

For a single node deployment the referenced configuration should be suitable. But aggregating multiple applications, nodes and systems a deployment like [loki/getting-started](https://github.com/grafana/loki/tree/main/examples/getting-started) or [loki/production](https://github.com/grafana/loki/tree/main/production) should be considered.

Therefore, the Grafana's [production template](), containing separate read and write instances, a nginx gateway and a MinIO storage instance, was utilized in this setup.

### Sending logs with Promtail

Using the recommended client to send logs, avoids configuration differences and generalizes the uses cases. Furthermore, a comparison with a custom implementation is possible 

See this [gist](https://gist.github.com/ruanbekker/c6fa9bc6882e6f324b4319c5e3622460) and the associated [article](https://ruanbekker.medium.com/logging-with-docker-promtail-and-grafana-loki-d920fd790ca8) for information on scraping docker logs with Promtail.

### Changing the logging driver for a container

There are three methods to pass the logs of containerized applications save to Loki:

1. [on runtime](https://grafana.com/docs/loki/latest/clients/docker-driver/configuration/#change-the-default-logging-driver)

2. changing the [default logging driver](https://grafana.com/docs/loki/latest/clients/docker-driver/configuration/#change-the-default-logging-driver)

3. via the [compose file](https://grafana.com/docs/loki/latest/clients/docker-driver/configuration/#configure-the-logging-driver-for-a-swarm-service-or-compose)

>**Note**
>
>To avoid unexpected behavior or losing logs, we don't want to modify the default behavior and integrate the settings in our compose files.

## Collecting metrics

Prometheus scraps metrics from predefined targets and stores them in it's time-series database. Some applications like Grafana, MinIO or cAdvisor implement their own metrics endpoint, for others a custom endpoint may be developed (see [client libraries](https://prometheus.io/docs/instrumenting/clientlibs/) for additional information).

Monitor a docker host and it's running containers the following steps are necessary:

1. expose a metrics endpoint on the docker host to be scraped by Prometheus
2. add [cAdvisor](https://github.com/google/cadvisor) alongside our setup, which provides scrapable metrics per container

### Docker host

As described in [Docker docs](https://docs.docker.com/config/daemon/prometheus/), we modify the current ``.../.docker/deamon.json`` to expose a metrics endpoint:

```json
{
 "builder": { "gc": { "defaultKeepStorage": "20GB", "enabled": true } },
 "experimental": false,
 "features": { "buildkit": true }
 
}
```

becomes:

```json
{
 "builder": { "gc": { "defaultKeepStorage": "20GB", "enabled": true } },
 "features": { "buildkit": true },
 "metrics-addr" : "127.0.0.1:9323",
 "experimental" : true
}

```

### Container

See the official Prometheus [documentation](https://prometheus.io/docs/guides/cadvisor/) to monitor containers.

---

## Visualizing and Observability

### Building a custom Grafana image

For a setup behind a company proxy grafana requires additional certificates. Updating the certificates allows downloading plugins and dashboards via the GUI.

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

---

## Putting it all together

>**Note**
>
> Make sure you have all [Prerequisites](#Prerequisites)!

Pull and initialize the application stack:

```
.\up.ps1
```

Visit the user interfaces:

- check the created buckets in [MinIO](http://localhost:9006)
- monitor your running containers with [cAdvisor](http://localhost:8081)
- verify all scraping targets are up and running [Prometheus UI](http://localhost:9090/targets)
- visit [Grafana](http://localhost:3000)



Shutdown the stack:

```
.\shutdown.ps1
```

Restart the setup:

```
.\startup.ps1
```

Bring all containers down, make sure they are stopped and remove them  as well as the created bridge network afterwards.


setup the data sources in grafana:

pay attention to the auth of loki:
custom header key: "X-Scope-OrgID" val:1  see: https://github.com/grafana/loki/blob/main/production/docker/config/datasources.yaml

```
.\down.ps1
```
