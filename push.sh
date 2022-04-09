#!/usr/bin/env zsh

TAG=$1

docker push linkuistics/devanyware-headless:${TAG}
docker push linkuistics/devanyware-headfull:${TAG}