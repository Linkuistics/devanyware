#!/usr/bin/env zsh

set -euxo pipefail

./clean.sh

for name in headless headfull ; do 
    pushd $name
    echo "$name build of $(date)" > ../$name.build.log
    docker build -t linkuistics/devanyware-$name . | tee -a ../$name.build.log
    popd
done