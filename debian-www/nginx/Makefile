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
IMAGENAME=debian

all: build
	
build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .

phpbuild:	
	$(MAKE) -C ../php7-fpm build
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	sed -i "s*debian-base*debian-php-fpm*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}-php:${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 -p 443:443 \
	-v /srv/docker/${NAME}/tls:/etc/nginx/tls \
	-v /srv/docker/${NAME}/sites-enabled:/etc/nginx/sites-enabled \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

phprun:
	docker run -d --hostname ${NAME}-php --name ${NAME}-php \
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
