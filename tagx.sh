#!/usr/bin/env zsh

TAG=$1

regctl image copy linkuistics/devanyware-headless:latest linkuistics/devanyware-headless:${TAG}
regctl image copy linkuistics/devanyware-headfull:latest linkuistics/devanyware-headfull:${TAG}