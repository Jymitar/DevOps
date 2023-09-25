terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "img-prometheus" {
  name = "prom/prometheus:latest"
}

resource "docker_image" "img-grafana" {
  name = "grafana/grafana:latest"
}

# resource "docker_network" "appnet" {
#   name = "appnet"
#   driver = "bridge"
#   check_duplicate = true
# }

resource "docker_container" "prometheus" {
  name = "prometheus"
  image = docker_image.img-prometheus.image_id
  ports {
    internal = 9090
    external = 9090
  }

  networks_advanced {
    name = "appnet"
  }

  volumes {
    host_path = "/vagrant/terraform-monitoring/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
    read_only = true
  }
}

resource "docker_container" "grafana" {
  name = "grafana"
  image = docker_image.img-grafana.image_id

  networks_advanced {
    name = "appnet"
  }

  ports {
    internal = "3000"
    external = "3000"
  }

  volumes {
    host_path = "/vagrant/terraform-monitoring/datasource.yml"
    container_path = "/etc/grafana/provisioning/datasources/datasource.yml"
    read_only = true
  }
}