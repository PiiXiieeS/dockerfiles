.PHONY: all

NAMESPACE=maxder
IMAGENAME=alpine

all: tag scratch builder library mini build clean_build

tag:
	./scripts/architecture.sh

scratch:
	IMAGENAME=$(NAMESPACE)/$(IMAGENAME)-scratch REL=$(VERSION) ./scripts/mkimage-alpine-scratch.sh

builder:
	curl -Lo master.tar.gz https://codeload.github.com/gliderlabs/docker-alpine/legacy.tar.gz/master
	tar -xf master.tar.gz
	rm master.tar.gz
	echo "Set builder images to FROM ${IMAGENAME}-scratch"
	sed -i "/FROM/ s:.*:FROM $(NAMESPACE)/$(IMAGENAME)-scratch:" ./gliderlabs-docker-alpine*/builder/Dockerfile
	sed -i "s*$(NAMESPACE)/$(IMAGENAME)-scratch*$(NAMESPACE)/$(IMAGENAME)-scratch:ARCHTAG*g" ./gliderlabs-docker-alpine*/builder/Dockerfile
	docker build --rm -t $(NAMESPACE)/$(IMAGENAME)-builder:ARCHTAG ./gliderlabs-docker-alpine*/builder

library:
	echo "build library alpine"
	cd ./gliderlabs-docker-alpine* && docker run --name alpine-build-ARCHTAG ${NAMESPACE}/${IMAGENAME}-builder:ARCHTAG -s -t UTC -r edge -m http://dl-4.alpinelinux.org/alpine > versions/library-edge/rootfs.tar.gz
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}:ARCHTAG ./gliderlabs-docker-alpine*/versions/library-edge

mini:
	echo "build alpine-mini based on gliderlabs/alpine"
	docker rm -f alpine-build-ARCHTAG
	cd ./gliderlabs-docker-alpine* && docker run --name alpine-build-ARCHTAG ${NAMESPACE}/${IMAGENAME}-builder:ARCHTAG -s -c -t UTC -r edge -m http://alpine.gliderlabs.com/alpine > versions/gliderlabs-edge/rootfs.tar.gz
	cd ./gliderlabs-docker-alpine* && docker  build --rm -t ${NAMESPACE}/${IMAGENAME}-mini:ARCHTAG versions/gliderlabs-edge

build:
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-base:ARCHTAG .

clean_build:
	rm -r ./gliderlabs-docker-alpine*
	docker rmi -f maxder/alpine-scratch:ARCHTAG
	docker rmi -f maxder/alpine-builder:ARCHTAG
	docker rmi -f maxder/alpine-min:ARCHTAG
	docker rmi -f maxder/alpine:ARCHTAG
