FROM ghcr.io/helmfile/helmfile-ubuntu:v1.1.8

LABEL org.opencontainers.image.source=https://github.com/deftdevs/containers

## Run noninteractive
ARG DEBIAN_FRONTEND=noninteractive

## Install prerequisites and main packages except for Azure CLI and Podman
RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
        apt-transport-https \
        ca-certificates \
        curl \
        git \
        gnupg \
        lsb-release \
        jq \
        make \
        ncat \
        postgresql-client \
        pwgen \
        sudo \
        unzip \
        wget \
        yq \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Download and install the Microsoft signing key and add the Azure CLI software repository
## TODO: Suites should be switched back to `$(lsb_release -cs)` later
RUN mkdir -p /etc/apt/keyrings && \
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg && \
    tee /etc/apt/sources.list.d/azure-cli.sources <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: noble
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg
EOF

## Install Azure CLI
RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
        azure-cli \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Install Podman and related packages
RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
        fuse-overlayfs \
        podman \
        uidmap \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Add configs for running Podman rootfull or rootless in a container
ADD https://raw.githubusercontent.com/containers/image_build/main/podman/containers.conf /etc/containers/containers.conf
ADD https://raw.githubusercontent.com/containers/image_build/main/podman/podman-containers.conf ${HOME}/.config/containers/containers.conf

## Create directory for rootless Podman (using HOME from upstream image)
RUN mkdir -p ${HOME}/.local/share/containers && \
    chmod 644 /etc/containers/containers.conf

## Configure Helmfile user and group
ARG HELMFILE_USER="helmfile"
ARG HELMFILE_GROUP=${HELMFILE_USER}

## Reassign the groups and user ID's of the ubuntu group and user to the helmfile group and user
RUN groupmod -n ${HELMFILE_GROUP} ubuntu && \
    usermod -l ${HELMFILE_USER} ubuntu && \
    usermod -aG ${HELMFILE_GROUP} ${HELMFILE_USER} && \
    usermod --add-subuids 10000-65536 ${HELMFILE_USER} && \
    usermod --add-subgids 10000-65536 ${HELMFILE_GROUP} && \
    usermod -d ${HOME} ${HELMFILE_USER} && \
    chown -R ${HELMFILE_USER}:root ${HOME} && \
    chmod -R 770 ${HOME} && \
    rm -rf /home/ubuntu

## Define volumes for rootfull and rootless Podman
## Note: VOLUME options must always happen after the chown call above
## RUN commands can not modify existing volumes
VOLUME /var/lib/containers
VOLUME ${HOME}/.local/share/containers

## Environment variables taken over from official Podman image
ENV _CONTAINERS_USERNS_CONFIGURED="" \
    BUILDAH_ISOLATION=chroot

## Disable Helmfile upgrade check
ENV HELMFILE_UPGRADE_NOTICE_DISABLED="true"

USER ${HELMFILE_USER}

## Remove WORKDIR and ENTRYPOINT FROM base image
WORKDIR /
ENTRYPOINT []
