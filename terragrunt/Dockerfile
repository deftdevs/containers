ARG TERRAGRUNT_VERSION=0.52.7
ARG AZ_VERSION=2.51.0

FROM ghcr.io/opentofu/opentofu:1.6.2

LABEL org.opencontainers.image.source https://github.com/deftdevs/containers
## Set label with node path for Azure DevOps Pipelines
LABEL com.azure.dev.pipelines.agent.handler.node.path /usr/bin/node

## Create a user and group

ARG USER="opentofu"
ARG UID="1000"
ARG GROUP="${USER}"
ARG GID="${UID}"

RUN addgroup -g ${GID} -S ${GROUP} && \
    adduser -u ${UID} -S ${USER} -G ${GROUP}

## Set the home directory

ARG HOME="/${USER}"
ENV HOME="${HOME}"

RUN mkdir -p  ${HOME} && \
    chown ${USER}:${GROUP} ${HOME}

## Install packages

RUN apk add --no-cache \
    ansible \
    bash \
    cargo \
    gcc \
    libffi-dev \
    make \
    musl-dev \
    nodejs \
    openssl-dev \
    postgresql \
    py3-pip \
    python3-dev \
    shadow \
    sudo

ARG AZ_VERSION

RUN pip install --upgrade pip \
    && pip install -Iv azure-cli==${AZ_VERSION}

## Install Terragrunt

ARG TERRAGRUNT_VERSION

RUN wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" -O /usr/local/bin/terragrunt --no-verbose \
    && chmod +x /usr/local/bin/terragrunt

USER ${USER}

## Adjust WORKDIR and remove ENTRYPOINT FROM base image

WORKDIR ${HOME}
ENTRYPOINT []

## Set the default command

CMD ["/usr/local/bin/terragrunt"]
