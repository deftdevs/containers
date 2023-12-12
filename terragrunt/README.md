Terragrunt
==========

## Binaries

This Docker image contains the following primary binaries:

* [`terraform`](https://github.com/hashicorp/terraform/releases)
* [`terragrunt`](https://github.com/gruntwork-io/terragrunt/releases)

Terraform version compatibility table:

* https://terragrunt.gruntwork.io/docs/getting-started/supported-terraform-versions/

Furthermore, this Docker image contains the following secondary binaries:

* `az` (Azure CLI)
* `make`
* `psql` (Postgresql CLI)

## Example:

```
on:
  push:
    branches: [ main ]

jobs:
  terragrunt:
    runs-on: ubuntu-20.04
    container:
      image: ghcr.io/aservo/terragrunt:latest
    steps:
    - name: Versions
      run: |
        terraform version
        terragrunt version
```

## Development

Clone the repo and change to the directory with the following commands:

```
git clone https://github.com/aservo/docker-terragrunt.git
cd docker-terragrunt
```

Build image:

```
docker build .
...
Successfully built a123b4c567de
```

Run image:

```
$ docker run -it a123b4c567de bash
bash-5.1#
```

Execute commands inside the container:

```
bash-5.1# terragrunt -v
terragrunt version vX.Y.Z
```
