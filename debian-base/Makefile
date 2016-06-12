.PHONY: all build push

CURRENT_DIRECTORY := $(shell pwd)
UNAME := $(shell uname -m)
ifeq ($(UNAME), x86_64)
 ARCHTAG=x86_64
endif
ifeq ($(UNAME), armv6l)
 ARCHTAG=armhf
endif
ifeq ($(UNAME), armv7l)
 ARCHTAG=armhf
endif

NAME=base
NAMESPACE=maxder
IMAGENAME=debian

all: debootstrap build

debootstrap:
	./scripts/debootstrap.sh
	
build:
	ARCHTAG=${ARCHTAG} eval echo "$$(cat ./Dockerfile)" 2> /dev/null | docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} -

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

