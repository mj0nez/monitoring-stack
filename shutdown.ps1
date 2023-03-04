# Script to stop the logging and monitoring layer consecutively

# the monitoring layer: grafana, timescale ...
docker compose -f compose-observe.yml stop

# the logging layer: loki, prometheus
docker compose -f compose-infra.yml stop
