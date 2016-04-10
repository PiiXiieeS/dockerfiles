.PHONY: all build run remove push

NAME=redis
NAMESPACE=maxder
IMAGENAME=alpine

all: tag

tag:
	./scripts/architecture.sh
	make build
	
build:  
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:
	docker run -d --hostname ${NAME} --name ${NAME}-server -p 6379:6379 -v /srv/docker/redis:/var/lib/redis ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

remove:
	docker rm -f ${NAME}-server 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
