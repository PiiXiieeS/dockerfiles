.PHONY: all build run remove push

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

NAME=mahara
NAMESPACE=maxder
IMAGENAME=alpine

all: build
	
build:
	sed -i "s*alpine-nginx-php:ARCHTAG*alpine-nginx-php:${ARCHTAG}*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .
	
run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 -p 443:443 \
	-v /srv/docker/${NAME}/data:/var/${NAME}/data \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

remove:
	docker rm -f ${NAME} 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}
