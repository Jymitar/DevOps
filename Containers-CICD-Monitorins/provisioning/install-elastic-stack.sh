#!/bin/bash

echo "* Install Elasticsearch"
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.4.3-amd64.deb
sudo dpkg -i elasticsearch*.deb

echo "* Install Logstash"
wget https://artifacts.elastic.co/downloads/logstash/logstash-8.4.3-amd64.deb
sudo dpkg -i logstash-*.deb

echo "* Install Kibana"
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.4.3-amd64.deb
sudo dpkg -i kibana-*.deb

echo "* Deploy configuration for Elasticsearch"
cp -v /vagrant/monitoring/elasticsearch.yml /etc/elasticsearch/

echo "* Correct the Java heap size for Elasticsearch"
cat > /etc/elasticsearch/jvm.options.d/jvm.options <<EOF
-Xms512m
-Xmx512m
EOF
    
echo "* Create beats configuration for Logstash"
cat > /etc/logstash/conf.d/beats.conf << EOF
input {
  beats {
    port => 5044
  }
}
output {
  elasticsearch {
    hosts => ["http://monitoring:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  }
}
EOF

echo "* Deploy configuration for Kibana"
cp -v /vagrant/monitoring/kibana.yml /etc/kibana/

echo "* Restart the services"
systemctl daemon-reload
systemctl enable --now elasticsearch
systemctl enable --now logstash
systemctl enable --now kibana