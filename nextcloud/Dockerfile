FROM nextcloud:28.0.1-apache

LABEL org.opencontainers.image.source https://github.com/deftdevs/containers

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        ffmpeg \
    ; \
    rm -rf /var/lib/apt/lists/*;
