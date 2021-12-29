######################################################
# DATABASE SERVICE
######################################################

resource "docker_image" "postgres" {
  name = "postgres:13.5"
}

resource "docker_image" "redis" {
  name = "oak/redis:6.2-nc"

  build {
    path = "../../docker/image/redis/"
    tag  = ["oak/redis:latest"]
  }
}



resource "docker_image" "redisinsight" {
  name = "redislabs/redisinsight:1.11.0"
}

######################################################
# AIRFLOW
######################################################

resource "docker_image" "airflow_base" {
  name = "oak/airflow:2.2.2-base"

  build {
    path = "../../docker/image/airflow-base/"
    tag  = ["oak/airflow:latest"]
  }
}

resource "docker_image" "airflow_celery" {
  name       = "oak/airflow:2.2.2-celery"
  depends_on = [docker_image.airflow_base]

  build {
    path = "../../docker/image/airflow-celery/"
    tag  = ["oak/airflow:latest"]
  }
}
