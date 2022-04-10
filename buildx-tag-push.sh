#!/usr/bin/env zsh

TAG=$1

set -euxo pipefail

./clean.sh

for name in headless headfull ; do 
    pushd $name
    echo "$name build of $(date)" > ../$name.build.log
    docker buildx build --platform linux/arm64,linux/amd64 --push --tag linkuistics/devanyware-${name}:latest --tag linkuistics/devanyware-${name}:${TAG} . | tee -a ../$name.build.log
    popd
done
