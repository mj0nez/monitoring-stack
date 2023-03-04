# Script to startup the logging and monitoring layer consecutively

# the logging layer: loki, prometheus
docker compose -f docker-compose-loki.yml start

# the monitoring layer: grafana, timescale ...
docker compose -f docker-compose.yml start