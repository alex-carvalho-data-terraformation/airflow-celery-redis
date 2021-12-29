######################################################
# DATABASE SERVICES
######################################################

resource "docker_container" "postgres" {
  image   = "postgres:13.5"
  name    = "postgres"
  restart = "always"

  ports {
    external = 5432
    internal = 5432
  }

  networks_advanced {
    name = docker_network.airflow_network.name
  }

  env = [
    "POSTGRES_DB=airflow_db",
    "POSTGRES_USER=airflow",
    "POSTGRES_PASSWORD=airflow"
  ]

  volumes {
    volume_name    = "postgres-celery-vol"
    container_path = "/var/lib/postgresql/data"
  }

  healthcheck {
    test     = ["CMD", "pg_isready", "-q", "-d", "airflow_db", "-U", "airflow"]
    interval = "5s"
    timeout  = "5s"
    retries  = 25
  }
}

resource "docker_container" "redis" {
  image   = "oak/redis:6.2-nc"
  name    = "redis"
  restart = "always"

  networks_advanced {
    name = docker_network.airflow_network.name
  }

  command = ["redis-server", "--requirepass", "redispass"]

  healthcheck {
    test     = ["CMD", "nc", "-z", "redis", "6379"]
    interval = "5s"
    timeout  = "5s"
    retries  = 25
  }
}

resource "docker_container" "redisinsight" {
  image      = "redislabs/redisinsight:1.11.0"
  name       = "redisinsight"
  restart    = "always"
  depends_on = [docker_container.redis]

  ports {
    external = 8001
    internal = 8001
  }

  networks_advanced {
    name = docker_network.airflow_network.name
  }

  healthcheck {
    test     = ["CMD", "ping", "-c", "3", "localhost"]
    interval = "5s"
    timeout  = "5s"
    retries  = 25
  }
}