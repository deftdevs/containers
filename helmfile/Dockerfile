FROM ghcr.io/helmfile/helmfile-ubuntu:v0.167.1

LABEL org.opencontainers.image.source https://github.com/deftdevs/containers

## Run noninteractive
ARG DEBIAN_FRONTEND=noninteractive

## Install main packages
RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
        curl \
        git \
        jq \
        make \
        ncat \
        postgresql-client \
        pwgen \
        python3-pip \
        sudo \
        unzip \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Install PIP packages
ARG AZ_VERSION=2.59.0
RUN pip3 install -Iv azure-cli==${AZ_VERSION}

RUN pip3 install yq

## Disable Helmfile upgrade check
ENV HELMFILE_UPGRADE_NOTICE_DISABLED="true"

## Configure Helmfile user and group (using HOME from upstream image)
ARG HELMFILE_UID=1000
ARG HELMFILE_GID=${HELMFILE_UID}
ARG HELMFILE_USER="helmfile"
ARG HELMFILE_GROUP=${HELMFILE_USER}

RUN groupadd -g ${HELMFILE_GID} ${HELMFILE_GROUP} && \
    useradd -m -u ${HELMFILE_UID} -g ${HELMFILE_GROUP} ${HELMFILE_USER}

RUN chown -R root:${HELMFILE_GROUP} ${HOME} && \
    chmod -R 770 ${HOME}

USER ${HELMFILE_USER}

## Remove WORKDIR and ENTRYPOINT FROM base image
WORKDIR /
ENTRYPOINT []
