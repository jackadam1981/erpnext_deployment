#! /bin/bash

# Define variables

TRAEFIK_USER="admin"
TRAEFIK_PASSWORD="admin"
TRAEFIK_PORT="8069"
TRAEFIK_DOMAIN="any.domain"
HTTP_PUBLISH_PORT="18080"
HTTPS_PUBLISH_PORT="18443"

DB_PASSWORD=1234567890

SITE_NAME="erpnext.jackadam.top"

# Copy necessary files
cp ../frappe_docker/example.env .env

# Update .env file with variables
sed -i "s/^HTTP_PUBLISH_PORT=.*$/HTTP_PUBLISH_PORT=${HTTP_PUBLISH_PORT}/" .env
sed -i "/^HTTP_PUBLISH_PORT=.*/a HTTPS_PUBLISH_PORT=${HTTPS_PUBLISH_PORT}" .env
sed -i "s/^FRAPPE_SITE_NAME_HEADER=.*$/FRAPPE_SITE_NAME_HEADER=${SITE_NAME}/" .env
sed -i "s/^DB_PASSWORD.*$/DB_PASSWORD=${DB_PASSWORD}/" .env
sed -i "s/^SITES=.*$/SITES=${SITE_NAME}/" .env
echo "TRAEFIK_PORT=${TRAEFIK_PORT}" >> .env

# 生成MD5哈希
TRAEFIK_AUTH=$(openssl passwd -apr1 "${TRAEFIK_PASSWORD}" | sed 's/\$/$$/g')
echo "HASHED_PASSWORD=${TRAEFIK_AUTH}" >> .env
echo "TRAEFIK_DOMAIN=${TRAEFIK_DOMAIN}" >> .env

# Generate Docker Compose configuration
docker compose \
    --env-file .env \
    -f ../frappe_docker/compose.yaml \
    -f ../frappe_docker/overrides/compose.mariadb.yaml \
    -f ../frappe_docker/overrides/compose.redis.yaml \
    -f ../frappe_docker/overrides/compose.proxy.yaml \
    -f create-site.yaml \
    -f ipv6.yaml \
    config > compose.yaml

# Uncomment the following line to start the services
# docker compose -f compose.yaml up -d


