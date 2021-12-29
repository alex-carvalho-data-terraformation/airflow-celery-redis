######################################################
# AIRFLOW
######################################################

resource "docker_container" "airflow_webserver" {
  image   = "oak/airflow:2.2.2-celery"
  name    = "airflow-webserver"
  restart = "always"
  depends_on = [
    docker_container.postgres,
    docker_container.redis
  ]

  ports {
    external = 8080
    internal = 8080
  }

  networks_advanced {
    name = docker_network.airflow_network.name
  }

  env = [
    "POSTGRES_DB=airflow_db",
    "POSTGRES_USER=airflow",
    "POSTGRES_PASSWORD=airflow",
    "REDIS_PASSWORD=redispass",
    "AIRFLOW__CORE__FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho="
  ]

  volumes {
    host_path      = "${path.cwd}/../../../mnt/airflow/dags/"
    container_path = "/opt/airflow/dags"
  }

  command = ["webserver"]

  healthcheck {
    test     = ["CMD", "nc", "-z", "airflow-webserver", "8080"]
    interval = "5s"
    timeout  = "5s"
    retries  = 25
  }

}

resource "docker_container" "airflow_flower" {
  image      = "oak/airflow:2.2.2-celery"
  name       = "airflow-flower"
  restart    = "always"
  depends_on = [docker_container.redis]

  ports {
    external = 5555
    internal = 5555
  }

  networks_advanced {
    name = docker_network.airflow_network.name
  }

  env = [
    "REDIS_PASSWORD:=redispass",
    "AIRFLOW_WEBSERVER_HOST=${docker_container.airflow_webserver.name}"
  ]

  command = ["airflow", "celery", "flower"]

  healthcheck {
    test     = ["CMD", "nc", "-z", "airflow-flower", "5555"]
    interval = "5s"
    timeout  = "5s"
    retries  = 25
  }
}

resource "docker_container" "airflow_scheduler" {
  image      = "oak/airflow:2.2.2-celery"
  name       = "airflow-scheduler"
  restart    = "always"
  depends_on = [docker_container.airflow_webserver]

  networks_advanced {
    name = docker_network.airflow_network.name
  }

  env = [
    "POSTGRES_DB=airflow_db",
    "POSTGRES_USER=airflow",
    "POSTGRES_PASSWORD=airflow",
    "REDIS_PASSWORD=redispass",
    "AIRFLOW__CORE__FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=",
    "AIRFLOW_WEBSERVER_HOST=${docker_container.airflow_webserver.name}"
  ]

  volumes {
    host_path      = "${path.cwd}/../../../mnt/airflow/dags/"
    container_path = "/opt/airflow/dags"
  }

  command = ["airflow", "scheduler"]

  healthcheck {
    #test = ["CMD", "curl", "airflow-webserver:8080/health", "|", "tr", "-d", "'\n \"{'", "|", "grep", "'scheduler:status:healthy'"]
    test     = ["CMD-SHELL", "curl ${docker_container.airflow_webserver.name}:8080/health | tr -d '\n \"{' | grep 'scheduler:status:healthy'"]
    interval = "5s"
    timeout  = "5s"
    retries  = 25
  }
}

resource "docker_container" "worker" {
  image      = "oak/airflow:2.2.2-celery"
  name       = "airflow-worker"
  restart    = "always"
  depends_on = [docker_container.airflow_scheduler]

  networks_advanced {
    name = docker_network.airflow_network.name
  }

  env = [
    "POSTGRES_DB=airflow_db",
    "POSTGRES_USER=airflow",
    "POSTGRES_PASSWORD=airflow",
    "REDIS_PASSWORD=redispass",
    "AIRFLOW__CORE__FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=",
    "AIRFLOW_WEBSERVER_HOST=${docker_container.airflow_webserver.name}"
  ]

  volumes {
    host_path      = "${path.cwd}/../../../mnt/airflow/dags/"
    container_path = "/opt/airflow/dags"
  }

  command = ["airflow", "celery", "worker"]

  healthcheck {
    test     = ["CMD", "nc", "-z", "airflow-worker", "8793"]
    interval = "5s"
    timeout  = "5s"
    retries  = 25
  }

}
