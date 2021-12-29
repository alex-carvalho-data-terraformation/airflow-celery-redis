terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

provider "docker" {}

######################################################
# NETWORK
######################################################

resource "docker_network" "airflow_network" {
  name = "airflow-celery-net"
}
