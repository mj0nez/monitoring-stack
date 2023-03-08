# Script to startup the logging and monitoring layer consecutively

docker compose -f compose-observe.yml down
docker compose -f compose-metrics.yml down
docker compose -f compose-infra.yml down