.PHONY: all build push

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
	sed -i "s*ARCHTAG*${ARCHTAG}*g" ./scripts/debootstrap.sh
	./scripts/debootstrap.sh
	
build:
	$(MAKE) debootstrap
	sed -i "s*alpine-mini:ARCHTAG*alpine-mini:${ARCHTAG}*g" ./Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

