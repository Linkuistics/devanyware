#!/usr/bin/env zsh

TAG=$1

docker tag soops/devanyware/headless docker.soops.intern/soops/devanyware/headless:$TAG
docker rmi soops/devanyware/headless:latest

docker tag soops/devanyware/headfull docker.soops.intern/soops/devanyware/headfull:$TAG
docker rmi soops/devanyware/headfull:latest
