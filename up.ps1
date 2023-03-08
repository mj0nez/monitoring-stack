# Script to startup the logging and monitoring layer consecutively

docker compose -f compose-infra.yml up -d
docker compose -f compose-metrics.yml up -d
docker compose -f compose-observe.yml up -d