#!/bin/env bash

## Script to build all Dockerfiles that have changed since the last tag of the corresponding image.

## Exit when any command fails
set -e
set -o pipefail

## Get the images as the first argument of the script and the owner as the second argument.
images=$(echo "$1" | tr '\n' ' ')
owner=${2:-"deftdevs"}

echo "Building images: $images"

## Iterate over all images.
for image in $images; do
    version=$(grep -m1 'FROM ' "$image/Dockerfile" | awk -F ':' '{print $2}' | sed 's/[^0-9.]//g')

    if [ -z "$version" ]; then
        echo "No version found in $image/Dockerfile FROM directive"
        exit 1
    fi

    echo "Found version $version in $image/Dockerfile"
    image_name="ghcr.io/$owner/$image:$version"

    echo "Building image $image_name"
    docker buildx build "$image" --tag "$image_name" --load
done
