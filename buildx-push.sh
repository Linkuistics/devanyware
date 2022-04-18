#!/usr/bin/env zsh

export VERSION_TAG=$1

set -euxo pipefail

./clean.sh

for name in headless headfull ; do 
    pushd $name
    echo "$name build of $(date)" > ../$name.build.log
    docker buildx build \
        --build-arg VERSION_TAG=${VERSION_TAG} \
        --platform linux/arm64,linux/amd64 \
        --tag linkuistics/devanyware-${name}:${VERSION_TAG} \
        --push \
        . \
    | tee -a ../$name.build.log
    popd
done
