#!/bin/bash

echo "* close repository ..."
git clone https://github.com/Jymitar/bgapp.git

echo "* stack initialize ..."
docker stack deploy -c bgapp/docker-compose-swarm.yaml bgapp