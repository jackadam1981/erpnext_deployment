#! /bin/bash

# Define variables
HTTP_PUBLISH_PORT="18080"
HTTPS_PUBLISH_PORT="18443"
TRAEFIK_PORT="8069"
SITE_NAME="erpnext.jackadam.top"

# Copy necessary files
cp ../frappe_docker/compose.yaml ./base.yaml
cp ../frappe_docker/example.env .env

# Update .env file with variables
sed -i "s/^HTTP_PUBLISH_PORT=.*$/HTTP_PUBLISH_PORT=${HTTP_PUBLISH_PORT}/" .env
sed -i "/^HTTP_PUBLISH_PORT=.*/a HTTPS_PUBLISH_PORT=${HTTPS_PUBLISH_PORT}" .env
sed -i "s/^FRAPPE_SITE_NAME_HEADER=.*$/FRAPPE_SITE_NAME_HEADER=${SITE_NAME}/" .env
sed -i "s/^SITES=.*$/SITES=${SITE_NAME}/" .env
echo "TRAEFIK_PORT=${TRAEFIK_PORT}" >> .env

# Generate Docker Compose configuration
docker compose \
    -f base.yaml \
    -f ../frappe_docker/overrides/compose.mariadb.yaml \
    -f ../frappe_docker/overrides/compose.redis.yaml \
    -f traefik.yaml \
    -f create-site.yaml \
    -f ipv6.yaml \
    config > compose.yaml

# Uncomment the following line to start the services
# docker compose -f compose.yaml up -d


