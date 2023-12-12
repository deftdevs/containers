FROM nextcloud:27.1.4-apache

LABEL org.opencontainers.image.source https://github.com/deftdevs/containers

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        ffmpeg \
    ; \
    rm -rf /var/lib/apt/lists/*;
