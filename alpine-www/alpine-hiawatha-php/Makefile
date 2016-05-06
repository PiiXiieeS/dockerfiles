.PHONY: all build run remove push

NAME=hiawatha-php
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
	
build:  tag
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:armhf .

run:	tag
	docker run -d --hostname ${NAME} --name ${NAME} -p 80:80 -v /srv/docker/${NAME}/sites-enabled:/etc/hiawatha/sites-enabled -v /srv/docker/${NAME}/www:/usr/share/webapps ${NAMESPACE}/${IMAGENAME}-${NAME}:armhf

remove: 
	docker rm -f ${NAME} 

push:	tag
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:armhf
