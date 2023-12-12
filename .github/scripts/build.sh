#!/bin/env bash

## Script to build all Dockerfiles that have changed since the last tag of the corresponding image.

## Get the images as the first argument of the script and the owner as the second argument.
images=$1
owner=${2:-"deftdevs"}

## Iterate over all images.
for image in $images; do
    version=$(grep -m1 'FROM' "$image/Dockerfile" | sed -E 's/.*:([0-9]+\.[0-9]+\.[0-9]+).*/\1/')

    if [ -z "$version" ]; then
        echo "No version found in $image/Dockerfile FROM directive"
        exit 1
    fi

    image_name="ghcr.io/$owner/$image:$version"

    echo "Building image $image_name"
    docker buildx build "$image" --tag "$image_name" --load
done
