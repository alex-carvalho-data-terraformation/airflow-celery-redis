# BUILD (manual): docker image build --rm -t oak/redis:6.2-nc .

FROM redis:6.2

LABEL com.oak.docker.image.maintainer="alex carvalho" \
      com.oak.docker.image.maintainer.email="alex.carvalho.data@gmail.com" \
      com.oak.docker.image.name="oak/redis" \
      com.oak.docker.image.tag="6.2-nc" \
      com.oak.docker.image.version="1.0.0" \
      com.oak.docker.image.description="Almost the same oficial redis:6.2 image, but with netcat, for healthcheck" \
      io.redis.version="6.2"

RUN apt update -y \
    && apt install -yqq --no-install-recommends netcat \
    && apt autoremove -yqq --purge \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
