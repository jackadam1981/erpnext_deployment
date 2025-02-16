#!/bin/bash

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker volume prune -f
docker volume rm $(docker volume ls -q) -f
docker network rm $(docker network ls -q) -f