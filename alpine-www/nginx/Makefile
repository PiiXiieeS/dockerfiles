.PHONY: all build run push

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

NAME=nginx
NAMESPACE=maxder
IMAGENAME=alpine
LOG="--log-driver json-file --log-opt max-size=1k --log-opt max-file=10"

all: build
	
build:
	sed -i "s*alpine-base:ARCHTAG*alpine-base:${ARCHTAG}*g" Dockerfile_NGINX
	mv Dockerfile_NGINX Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .
	mv Dockerfile Dockerfile_NGINX

phpbuild:
	$(MAKE) -C ../php-fpm build
	sed -i "s*alpine-php-fpm:ARCHTAG*alpine-php-fpm:${ARCHTAG}*g" Dockerfile_PHP
	mv Dockerfile_PHP Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}-php:${ARCHTAG} .
	mv Dockerfile Dockerfile_PHP

run:
	docker run ${LOG} -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 -p 443:443 \
	-v /srv/docker/${NAME}/tls:/etc/nginx/tls \
	-v /srv/docker/${NAME}/sites-enabled:/etc/nginx/sites-enabled \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

phprun:
	docker run ${LOG} -d --hostname ${NAME}-php --name ${NAME}-php \
	-p 80:80 -p 443:443 \
	-v /srv/docker/${NAME}-php/tls:/etc/nginx/tls \
	-v /srv/docker/${NAME}-php/sites-enabled:/etc/nginx/sites-enabled \
	${NAMESPACE}/${IMAGENAME}-${NAME}-php:${ARCHTAG}

remove: 
	docker rm -f ${NAME}

phpremove:
	docker rm -f ${NAME}-php
	

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

phppush:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}-php:${ARCHTAG}
