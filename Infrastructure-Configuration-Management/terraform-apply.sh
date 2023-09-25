#!/bin/bash

# Install Kafka
terraform -chdir=/vagrant/terraform-kafka/ init
terraform -chdir=/vagrant/terraform-kafka/ apply -input=false -auto-approve

# Install Producer and Consumer apps
terraform -chdir=/vagrant/terraform-apps/ init
terraform -chdir=/vagrant/terraform-apps/ apply -input=false -auto-approve

# Install Prometheus and Grafana
terraform -chdir=/vagrant/terraform-monitoring/ init
terraform -chdir=/vagrant/terraform-monitoring/ apply -input=false -auto-approve

# Import Grafana Dashboard
terraform -chdir=/vagrant/terraform-monitoring/grafana-dashboard init
terraform -chdir=/vagrant/terraform-monitoring/grafana-dashboard apply -input=false -auto-approve