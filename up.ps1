# Script to startup the logging and monitoring layer consecutively

# the logging layer: loki, prometheus
docker compose -f compose-infra.yml up -d

# the monitoring layer: grafana, timescale ...
docker compose -f compose-observe.yml up -d