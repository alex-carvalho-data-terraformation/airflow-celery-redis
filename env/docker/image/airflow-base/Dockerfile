# BUILD (manual): docker image build --rm -t oak/airflow:2.2.2-base .

# Base Image
FROM python:3.7-slim-buster

LABEL com.oak.docker.image.maintainer="alex carvalho" \
      com.oak.docker.image.maintainer.email="alex.carvalho.data@gmail.com" \
      com.oak.docker.image.name="oak/airflow" \
      com.oak.docker.image.tag="2.2.2-base" \
      com.oak.docker.image.version="1.0.0" \
      com.oak.docker.image.description="Airflow container with this extras: crypto,celery,postgres,hive,jdbc,mysql,ssh,redis"

# Arguments that can be set with docker build
ARG AIRFLOW_VERSION=2.2.2
ARG AIRFLOW_HOME=/opt/airflow

ENV AIRFLOW_EXTRAS="celery,postgres,apache.hive,jdbc,mysql,ssh,redis"

# Export the environment variable AIRFLOW_HOME where airflow will be installed
ENV AIRFLOW_HOME=${AIRFLOW_HOME}
ENV AIRFLOW_UID="50000"

ENV PYTHON_VERSION=3.7
ENV CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-no-providers-${PYTHON_VERSION}.txt"

ENV DEBIAN_FRONTEND=noninteractive

ENV AIRFLOW_LINUX_DEPS="freetds-bin \
    krb5-user \
    ldap-utils \
    libffi6 \
    libsasl2-2 \
    libsasl2-modules \
    libssl1.1 \
    locales  \
    lsb-release \
    sasl2-bin \
    sqlite3 \
    unixodbc \
    default-libmysqlclient-dev \
    libsasl2-dev"

ENV USEFUL_LINUX_PACKS="python3-dev \
    wget \
    curl \
    git \
    apt-utils \
    zip \
    unzip \
    gcc \
    g++ \
    vim \
    netcat"

# Install dependencies and tools
RUN apt-get update -y \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
    ${USEFUL_LINUX_PACKS} \
    ${AIRFLOW_LINUX_DEPS} \
    && apt-get autoremove -yqq --purge  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip

RUN pip install "apache-airflow[${AIRFLOW_EXTRAS}]==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Create airflow user
RUN useradd --uid "${AIRFLOW_UID}" --gid "0" --home-dir "${AIRFLOW_HOME}" -ms /bin/bash airflow \
    && mkdir -p "${AIRFLOW_HOME}/dags" \
    && mkdir -p "${AIRFLOW_HOME}/logs" \
    && chown -R "airflow:root" "${AIRFLOW_HOME}" \
    && find "${AIRFLOW_HOME}" -executable -print0 | xargs --null chmod g+x  \
    && find "${AIRFLOW_HOME}" -print0 | xargs --null chmod g+rw

VOLUME ${AIRFLOW_HOME}/dags

EXPOSE 8080

LABEL org.apache.airflow.version="${AIRFLOW_VERSION}" \
      org.apache.airflow.home="${AIRFLOW_HOME}" \
      org.apache.airflow.extras="${AIRFLOW_EXTRAS}" \
      com.oak.docker.image.linux.distro="debian" \
      org.python.version="${PYTHON_VERSION}"
