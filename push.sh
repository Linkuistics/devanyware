#!/usr/bin/env zsh

TAG=$(git describe --contains)
if [[ $TAG =~ 'release-' ]] then
	./tag.sh ${TAG#release-}
	docker push docker.soops.intern/soops/devanyware/headless:${TAG#release-}
	docker push docker.soops.intern/soops/devanyware/headfull:${TAG#release-}
fi