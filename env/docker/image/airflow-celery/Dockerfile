# BUILD (manual): docker image build --rm -t oak/airflow:2.2.2-celery .

FROM oak/airflow:2.2.2-base

LABEL com.oak.docker.image.maintainer="alex carvalho" \
      com.oak.docker.image.maintainer.email="alex.carvalho.data@gmail.com" \
      com.oak.docker.image.name="oak/airflow" \
      com.oak.docker.image.tag="2.2.2-celery" \
      com.oak.docker.image.version="1.0.0" \
      com.oak.docker.image.description="Airflow container to be instantiated webserver, flower, scheduler and worker in a Celery + postgres airflow deployment"

EXPOSE 8080 \
       5555

WORKDIR ${AIRFLOW_HOME}

COPY script/entrypoint.sh .

RUN chmod o+x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
