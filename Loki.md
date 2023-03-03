# Loki - The Logging Stack

Based [on](https://docs.technotim.live/posts/grafana-loki/) we want to aggregate the logs of our monitoring stack.

For a single node, proof of concept a the referenced configuration should be suitable. But aggregating multiple applications, nodes and systems a deployment like [loki/getting-started](https://github.com/grafana/loki/tree/main/examples/getting-started) should be considered.

## Prerequisites

- [Grafana Loki's Docker plugin](https://grafana.com/docs/loki/latest/clients/docker-driver/#docker-driver-client)
- setting up loki instance
- changing the containers log drivers

### Changing the logging driver for a container

There are different methods:

1. on runtime [doc](https://grafana.com/docs/loki/latest/clients/docker-driver/configuration/#change-the-default-logging-driver)

2. changing the default logging driver see [doc](https://grafana.com/docs/loki/latest/clients/docker-driver/configuration/#change-the-default-logging-driver)

3. via compose [doc](https://grafana.com/docs/loki/latest/clients/docker-driver/configuration/#configure-the-logging-driver-for-a-swarm-service-or-compose)

>**Note**
>
>To avoid unexpected behavior or losing logs, we don't want to modify the default behavior and integrate the settings in our compose files.
