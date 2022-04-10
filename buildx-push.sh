#!/usr/bin/env zsh

export VERSION_TAG=$1

set -euxo pipefail

./clean.sh

for name in headless headfull ; do 
    pushd $name
    echo "$name build of $(date)" > ../$name.build.log
    envsubst '$VERSION_TAG' < Dockerfile > Dockerfile.subst
    docker buildx build \
        --platform linux/arm64,linux/amd64 \
        --tag linkuistics/devanyware-${name}:${VERSION_TAG} \
        --push \
        --file Dockerfile.subst \
        . \
    | tee -a ../$name.build.log
    rm Dockerfile.subst
    popd
done
