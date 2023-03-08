# Script to startup the logging and monitoring layer consecutively

# the logging layer: loki, prometheus
docker compose -f compose-infra.yml start
docker compose -f compose-metrics.yml start
docker compose -f compose-observe.yml start