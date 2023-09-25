#!/bin/bash

# Start Gitea
docker compose -f /vagrant/docker/docker-compose.yml up -d

# Wait until ready
while true; do 
  echo 'Trying to connect to http://192.168.69.122:3000 ...'; 
  if [ $(curl -s -o /dev/null -w "%{http_code}" http://192.168.69.122:3000) == "200" ]; then 
    echo '... connected.'; 
    break; 
  else 
    echo '... no success. Sleep for 5s and retry.'; 
    sleep 5; 
  fi 
done

# Add Gitea User
docker container exec -u 1000 gitea gitea admin user create --username jmy --password jmypass --email jmy@retake.exam

# Project Clone
git clone https://github.com/shekeriev/treasure-finding-contest /tmp/retake

# Repository Modify
echo "Modified on $(date '+%Y-%m-%d %H:%M:%S')" >> /tmp/retake/README.md
cd /tmp/retake && git add . && git commit -m "Modified on $(date '+%Y-%m-%d %H:%M:%S')"

# Adding the repository to Gitea as public
cd /tmp/retake && git push -o repo.private=false http://jmy:jmypass@192.168.69.122:3000/jmy/retake

# Webhook Add
curl -X 'POST' 'http://192.168.69.122:3000/api/v1/repos/jmy/retake/hooks' \
  -H 'accept: application/json' \
  -H 'authorization: Basic '$(echo -n 'jmy:jmypass' | base64) \
  -H 'Content-Type: application/json' \
  -d '{
  "active": true,
  "branch_filter": "*",
  "config": {
    "content_type": "json",
    "url": "http://192.168.69.121:8080/gitea-webhook/post",
    "http_method": "post"
  },
  "events": [
    "push"
  ],
  "type": "gitea"
}'