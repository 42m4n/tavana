#!/bin/bash
set -a

NETWORKS="traefik-net prometheus"

for network in $NETWORKS; do
  # Check if the network already exists
  if ! docker network ls --format '{{.Name}}' | grep -wq "$network"; then
    echo "Creating network: $network"
    docker network create --attachable=true --driver=overlay "$network"
  else
    echo "Network $network already exists. Skipping creation."
  fi
done

DOMAIN=tavana.local
NEXUS_URL=docker.$DOMAIN

source traefik/traefik.env
docker stack deploy -c traefik/traefik.yml --detach=true traefik

source monlog/monlog.env
docker stack deploy -c monlog/monlog.yml --detach=true prometheus_stack

set +a