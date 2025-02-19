#!/bin/bash

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

docker network prune -f
docker volume prune -f
docker volume rm $(docker volume ls -q) -f