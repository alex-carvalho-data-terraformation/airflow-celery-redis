# <img src="img/terraform.png" alt="Terraform" height="30" style="vertical-align: middle;"> <img src="img/docker.png" alt="docker" height="30" style="vertical-align: middle;"> | execution

It's intended to be very fast, less than 1 min.   
Here are created and `docker containers` and `docker networks` and destroyed after use.  

## 1. Configuration

1. Go to terraform config dir for execution (from this README folder)
   
```bash
cd env/terraform/exec/
```

2. Initialize Terraform

```bash
terraform init
```

## 2. Deployment instructions

Execute the build.  

```bash
terraform apply
```

## 3. How to run tests

### <img src="img/terraform.png" alt="Terraform" height="30" style="vertical-align: middle;"> 3.1. Check terraform objects

```bash
terraform state list
```

*Expected output similar to:*

```bash
docker_container.airflow_flower
docker_container.airflow_scheduler
docker_container.airflow_webserver
docker_container.postgres
docker_container.redis
docker_container.redisinsight
docker_container.worker
docker_network.airflow_network
```

### <img src="img/docker.png" alt="docker" height="20" style="vertical-align: middle;"> 3.2. Check docker networks

```bash
docker network ls
```

*Expected output similar to:*

```bash
NETWORK ID     NAME                 DRIVER    SCOPE
2776444af1b7   airflow-celery-net   bridge    local
```

### <img src="img/docker.png" alt="docker" height="20" style="vertical-align: middle;"> 3.3. Check docker containers

```bash
docker container ls
```

*Expected output similar to:*

```bash
CONTAINER ID   IMAGE                           COMMAND                  CREATED         STATUS                   PORTS                              NAMES
4de53d79f2df   oak/airflow:2.2.2-celery        "./entrypoint.sh air…"   3 minutes ago   Up 3 minutes (healthy)   5555/tcp, 8080/tcp                 airflow-worker
157f69a55f64   oak/airflow:2.2.2-celery        "./entrypoint.sh air…"   3 minutes ago   Up 3 minutes (healthy)   0.0.0.0:5555->5555/tcp, 8080/tcp   airflow-flower
65ef50916109   oak/airflow:2.2.2-celery        "./entrypoint.sh air…"   3 minutes ago   Up 3 minutes (healthy)   5555/tcp, 8080/tcp                 airflow-scheduler
b6728a4670b2   oak/airflow:2.2.2-celery        "./entrypoint.sh web…"   3 minutes ago   Up 3 minutes (healthy)   5555/tcp, 0.0.0.0:8080->8080/tcp   airflow-webserver
a554f4ba6525   redislabs/redisinsight:1.11.0   "bash ./docker-entry…"   3 minutes ago   Up 3 minutes (healthy)   0.0.0.0:8001->8001/tcp             redisinsight
5d2271269acd   postgres:13.5                   "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes (healthy)   0.0.0.0:5432->5432/tcp             postgres
2f2f269eaea8   oak/redis:6.2-nc                "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes (healthy)   6379/tcp                           redis
```

## 4. URLs

#### airflow

[<img src="img/airflow.png" alt="Apache Airflow" height="60" style="vertical-align: middle;">](http://localhost:8080/)

http://localhost:8080/

|          |         |
|----------|---------|
| Username | airflow |
| Password | airflow |

#### airflow celery flower

<img src="img/celery.png" alt="celery flower" height="60" style="vertical-align: middle;">

http://localhost:5555/

#### redis insight

<img src="img/redisinsight.png" alt="redis insight" height="60" style="vertical-align: middle;">

http://localhost:8001/

|              |          |
|--------------|----------|
| **Host**     | redis    |
| **Port**     | 6379     |
| **Name**     | redis    |
| **Username** | *EMPTY*  |
| **Password** | redispass |

## 5. Undeploy instructions

### 5.1. Stop and remove docker containers and volumes

at `terraform/exec/`  

```bash
terraform destroy
```
