terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
    }
  }
}

provider "grafana" {
  url  = "http://192.168.69.100:3000/"
  auth = "admin:admin"
}

resource "grafana_dashboard" "metrics" {
  config_json = file("Dash.json")
}