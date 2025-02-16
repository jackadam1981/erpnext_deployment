#! /bin/bash

cp ../frappe_docker/compose.yaml ./base.yaml
cp ../frappe_docker/example.env .env
echo "HTTP_PUBLISH_PORT=8069" >>.env
sed -i 's/DB_HOST=/DB_HOST=db/' .env
sed -i 's/DB_PORT=/DB_PORT=3306/' .env
sed -i 's#REDIS_CACHE=#REDIS_CACHE=redis://redis-cache:6379#' .env
sed -i 's#REDIS_QUEUE=#REDIS_QUEUE=redis://redis-queue:6379#' .env
sed -i 's/FRAPPE_SITE_NAME_HEADER=/FRAPPE_SITE_NAME_HEADER=frontend/' .env

docker compose \
    -f base.yaml \
    -f ../frappe_docker/overrides/compose.mariadb.yaml \
    -f ../frappe_docker/overrides/compose.redis.yaml \
    -f ../frappe_docker/overrides/compose.noproxy.yaml \
    -f create-site.yaml \
    -f ipv6.yaml \
    config > compose.yaml

# docker compose -f compose.yaml up -d


