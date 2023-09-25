#!/bin/bash

echo "* Initialize it as the first node of the cluster ..."
docker swarm init --advertise-addr 192.168.99.101

echo "* Save swarm token ..."
docker swarm join-token -q worker > /vagrant/token.txt