.PHONY: all build run remove push

NAME=redis
NAMESPACE=maxder
IMAGENAME=alpine

all: tag

tag:
	./scripts/architecture.sh
	
build:  tag
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:armhf .

run:	tag
	docker run -d --hostname ${NAME} --name ${NAME}-server -p 6379:6379 -v /srv/docker/redis:/var/lib/redis ${NAMESPACE}/${IMAGENAME}-${NAME}:armhf

remove: tag
	docker rm -f ${NAME}-server 

push:	tag
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:armhf
