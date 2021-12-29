# environment #

## Quick summary  

<img src="img/terraform.png" alt="Terraform" height="30" style="vertical-align: middle;"> Terraform infrastructure containing: 

### network

- 1 network called `airflow-celery-net`

### containers <img src="img/docker.png" alt="docker" height="30" style="vertical-align: middle;">

- 1 <img src="img/postgresql.png" alt="PostgreSQL" height="20" style="vertical-align: middle;"> [PostgreSQL](#postgresql)
- 1 <img src="img/redis.png" alt="redis" height="20" style="vertical-align: middle;"> [redis](#redis)
- 1 <img src="img/redisinsight.png" alt="redis insight" height="20" style="vertical-align: middle;"> [redis insight](#redis-insight)
- 4 <img src="img/airflow.png" alt="Apache Airflow" height="20" style="vertical-align: middle;"> [airflow](#airflow)


# container descriptions #

## PostgreSQL

<img src="img/postgresql.png" alt="PostgreSQL" height="60" style="vertical-align: middle;">

### software

- PostgreSQL 13.5
- debian 11 (bullseye)

### exposed ports (host:container)

- 5432:5432

### container specific info

#### database
| database name | user    | password |
|---------------|---------|----------|
| airflow_db    | airflow | airflow  |


## redis

<img src="img/redis.png" alt="redis" height="60" style="vertical-align: middle;">

### software

- redis 6.2
- netcat
- debian 11 (bullseye)

### exposed ports (host:container)

- 6379:6379

### container specific info

#### database
| database name | user    | password  |
|---------------|---------|-----------|
| redis         | *EMPTY* | redispass |


## redis insight

<img src="img/redisinsight.png" alt="redis insight" height="60" style="vertical-align: middle;">

Web UI for redis

### software

- redis insight 1.11.0
- debian 10 (buster)

### exposed ports (host:container)

- 8001:8001

### URL

http://localhost:8001/

|              |           |
|--------------|-----------|
| **Host**     | redis     |
| **Port**     | 6379      |
| **Name**     | redis     |
| **Username** | *EMPTY*   |
| **Password** | redispass |


## airflow

<img src="img/airflow.png" alt="Apache Airflow" height="60" style="vertical-align: middle;"> <img src="img/celery.png" alt="celery flower" height="60" style="vertical-align: middle;">

### containers purpose

- 1 webserver
- 1 scheduler
- 1 flower
- 1 worker

All 4 containers use the same docker image.  
However, each one executes a different airflow process.

### software

- airflow 2.2.2
  - extras
    - celery
    - postgres
    - apache.hive
    - jdbc
    - mysql
    - ssh
    - redis
- python 3.7
- pip 21.2.4
- git 2.20.1
- netcat
- debian 10 (buster)

### exposed ports (host:container)

- 8080:8080
- 5555:5555

### container specific info

### URLs

#### airflow webserver

<img src="img/airflow.png" alt="Apache Airflow" height="60" style="vertical-align: middle;">

http://localhost:8080/

|              |         |
|--------------|---------|
| **Username** | airflow |
| **Password** | airflow |

#### airflow celery flower

<img src="img/celery.png" alt="celery flower" height="60" style="vertical-align: middle;">

http://localhost:5555/
