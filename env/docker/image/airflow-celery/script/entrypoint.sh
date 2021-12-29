#!/bin/bash

: "${POSTGRES_HOST:=postgres}"
: "${POSTGRES_PORT:=5432}"
: "${POSTGRES_DB:=airflow_db}"
: "${POSTGRES_USER:=airflow}"
: "${POSTGRES_PASSWORD:=airflow}"

: "${REDIS_HOST:=redis}"
: "${REDIS_PORT:=6379}"
: "${REDIS_PASSWORD:=redispass}"

: "${AIRFLOW_WEBSERVER_HOST:=webserver}"
: "${AIRFLOW_WEBSERVER_PORT:=8080}"

: "${AIRFLOW__CORE__LOAD_EXAMPLES:=False}"
: "${AIRFLOW__WEBSERVER__EXPOSE_CONFIG:=True}"
: "${AIRFLOW__CORE__FERNET_KEY:=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=}"

AIRFLOW__CORE__EXECUTOR="CeleryExecutor"
AIRFLOW__WEBSERVER__EXPOSE_CONFIG="True"
AIRFLOW__API__AUTH_BACKEND= 'airflow.api.auth.backend.basic_auth'

wait_for_service_startup() {
  local service_name="$1" service_host=$2 service_port=$3
  local service_dep_ok=1
  for i in {1..25}; do
    nc -z "$service_host" "$service_port"
    if [ $? -eq 0 ]; then
      service_dep_ok=0
      break
    fi
    echo "$service_name connection $i of 25 attempt has failed ($POSTGRES_HOST:$POSTGRES_PORT)"
    sleep 5
  done
  if [ ! $service_dep_ok -eq 0 ]; then
    echo "$service_name not reachable after 25"
    exit 1
  fi
}

wait_for_service_startup "postgres" $POSTGRES_HOST $POSTGRES_PORT
wait_for_service_startup "redis" $REDIS_HOST $REDIS_PORT

postgres_conn_str="$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB"

AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql+psycopg2://$postgres_conn_str"
AIRFLOW__CELERY__RESULT_BACKEND="db+postgresql://$postgres_conn_str"

AIRFLOW__CELERY__BROKER_URL="redis://:$REDIS_PASSWORD@$REDIS_HOST:$REDIS_PORT/0"

export AIRFLOW__CORE__LOAD_EXAMPLES \
       AIRFLOW__WEBSERVER__EXPOSE_CONFIG \
       AIRFLOW__CORE__FERNET_KEY \
       AIRFLOW__CORE__EXECUTOR \
       AIRFLOW__CORE__SQL_ALCHEMY_CONN \
       AIRFLOW__CELERY__RESULT_BACKEND \
       AIRFLOW__CELERY__BROKER_URL \
       AIRFLOW__WEBSERVER__EXPOSE_CONFIG \
       AIRFLOW__API__AUTH_BACKEND

case $1 in
  webserver)
    airflow db init
    airflow users create -e "admin@airflow.com" -f "airflow" -l "airflow" -p "airflow" -r "Admin" -u "airflow"
    airflow webserver
    ;;
  *)
    wait_for_service_startup "airflow webserver" $AIRFLOW_WEBSERVER_HOST $AIRFLOW_WEBSERVER_PORT
    exec "$@"
    ;;
esac