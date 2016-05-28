.PHONY: all build run remove push

NAME=redis
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
	
builddocker:  
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

build:	tag
	$(MAKE) builddocker
	
rundocker:
	docker run -d --hostname ${NAME} --name ${NAME}-server -p 6379:6379 -v /srv/docker/redis:/var/lib/redis ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

run:	tag
	$(MAKE) rundocker

remove: 
	docker rm -f ${NAME}-server 

push:	tag
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
