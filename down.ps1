# Script to startup the logging and monitoring layer consecutively

# the monitoring layer: grafana, timescale ...
docker compose -f compose-observe.yml down

# the logging layer: loki, prometheus
docker compose -f compose-infra.yml down