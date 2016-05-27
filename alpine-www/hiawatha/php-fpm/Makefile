.PHONY: all build run remove push

NAME=hiawatha-php
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
	
builddocker:  
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

build:  tag
	$(MAKE) builddocker

run:	tag
	docker run -d --hostname ${NAME} --name ${NAME} -p 80:80 -p 443:443 -v /srv/docker/${NAME}/tls:/etc/hiawatha/tls -v /srv/docker/${NAME}/sites-enabled:/etc/hiawatha/sites-enabled -v /srv/docker/${NAME}/webapps:/usr/share/webapps ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

quickstart: build
	$(MAKE) run

remove: 
	docker rm -f ${NAME} 

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
