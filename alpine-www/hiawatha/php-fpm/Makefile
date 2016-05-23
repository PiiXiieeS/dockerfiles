.PHONY: all build run remove push

NAME=hiawatha-php
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
	
build:  
	$(MAKE) tag
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:	
	$(MAKE) tag
	docker run -d --hostname ${NAME} --name ${NAME} -p 80:80 -p 443:443 -v /srv/docker/${NAME}/ssl:/etc/hiawatha/ssl -v /srv/docker/${NAME}/sites-enabled:/etc/hiawatha/sites-enabled -v /srv/docker/${NAME}/www:/usr/share/webapps ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

quickstart:
	$(MAKE) tag
	$(MAKE) build
	$(MAKE) run

remove: 
	docker rm -f ${NAME} 

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
