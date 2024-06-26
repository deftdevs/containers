FROM nextcloud:28.0.7-apache

LABEL org.opencontainers.image.source https://github.com/deftdevs/containers

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        libbz2-dev \
    ; \
    rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install -j "$(nproc)" \
        bz2 \
    ;
