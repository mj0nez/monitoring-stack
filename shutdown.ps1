# Script to stop the logging and monitoring layer consecutively

# the monitoring layer: grafana, timescale ...
docker compose -f docker-compose.yml stop

# the logging layer: loki, prometheus
docker compose -f docker-compose-loki.yml stop
