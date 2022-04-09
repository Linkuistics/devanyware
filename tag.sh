#!/usr/bin/env zsh

TAG=$1

docker tag linkuistics/devanyware-headless linkuistics/devanyware-headless:$TAG
docker tag linkuistics/devanyware-headfull linkuistics/devanyware-headfull:$TAG