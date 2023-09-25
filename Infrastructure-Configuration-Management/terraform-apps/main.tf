terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "img-kafka-disc" {
  name = "shekeriev/kafka-discoverer:latest"
}

resource "docker_image" "img-kafka-obs" {
  name = "shekeriev/kafka-observer:latest"
}

# resource "docker_network" "appnet" {
#   name = "appnet"
#   driver = "bridge"
#   check_duplicate = true
# }

resource "docker_container" "kafka-discoverer" {
  name = "kafka-discoverer"
  image = docker_image.img-kafka-disc.image_id
  env = ["BROKER=kafka:9092", "TOPIC=animal-facts", "METRICPORT=8000"]

  networks_advanced {
    name = "appnet"
  }
  ports {
    internal = "8000"
    external = "8000"
  }
}

resource "docker_container" "kafka-observer" {
  name = "kafka-observer"
  image = docker_image.img-kafka-obs.image_id
  env = ["BROKER=kafka:9092", "TOPIC=animal-facts", "APPPORT=5000"]

  networks_advanced {
    name = "appnet"
  }
  ports {
    internal = "5000"
    external = "5000"
  }
}