FROM ghcr.io/helmfile/helmfile-ubuntu:v0.168.0

LABEL org.opencontainers.image.source=https://github.com/deftdevs/containers

## Run noninteractive
ARG DEBIAN_FRONTEND=noninteractive

## Install prerequisites
RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Download and install the Microsoft signing key and add the Azure CLI software repository
RUN mkdir -p /etc/apt/keyrings && \
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg && \
    tee /etc/apt/sources.list.d/azure-cli.sources <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: $(lsb_release -cs)
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg
EOF

## Install main packages
RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
        azure-cli \
        curl \
        git \
        jq \
        make \
        ncat \
        podman \
        postgresql-client \
        pwgen \
        sudo \
        unzip \
        wget \
        yq \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Disable Helmfile upgrade check
ENV HELMFILE_UPGRADE_NOTICE_DISABLED="true"

## Configure Helmfile user and group (using HOME from upstream image)
ARG HELMFILE_USER="helmfile"
ARG HELMFILE_GROUP=${HELMFILE_USER}

## Reassign the groups and user ID's of the ubuntu group and user to the helmfile group and user
RUN groupmod -n ${HELMFILE_GROUP} ubuntu && \
    usermod -l ${HELMFILE_USER} ubuntu && \
    usermod -aG ${HELMFILE_GROUP} ${HELMFILE_USER}

RUN chown -R root:${HELMFILE_GROUP} ${HOME} && \
    chmod -R 770 ${HOME}

USER ${HELMFILE_USER}

## Remove WORKDIR and ENTRYPOINT FROM base image
WORKDIR /
ENTRYPOINT []
