#!/bin/env bash

## Script to determine which Dockerfiles have changed since the last tag of the corresponding image.
## This script is used by the GitHub Action to determine which images need to be built.

## Find all directories that contain a Dockerfile in the second level and print the name of the directory,
## e.g. ./nextcloud/Dockerfile would be printed as nextcloud.
dockerfiles=$(find . -mindepth 2 -maxdepth 2 -name Dockerfile -printf '%h\n' | sed -E 's/^\.\///' | sort | uniq)

## Iterate over all directories that contain a Dockerfile.
for dockerfile in $dockerfiles; do
    ## Try to find a Git tag with prefix "$dockerfile-" and print the latest one.
    tag=$(git tag -l "$dockerfile-*" --sort=-v:refname | head -n 1)

    ## If no tag was found, use the reference of the root commit
    if [ -z "$tag" ]; then
        tag=$(git rev-list --max-parents=0 HEAD)
    fi

    ## Determine whether there have been changes since the last tag and print the directory name if so.
    if [ -n "$(git diff --name-only "$tag..HEAD" "$dockerfile/Dockerfile")" ]; then
        echo "$dockerfile"
    fi
done
