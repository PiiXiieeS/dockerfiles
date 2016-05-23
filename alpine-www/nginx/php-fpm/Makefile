.PHONY: all build run remove push

NAME=nginx-php
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
	
build:  tag
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:	tag
	docker run -d --hostname ${NAME} --name ${NAME} -p 80:80 -p 443:443 -v /srv/docker/${NAME}/nginx/tls:/etc/nginx/tls -v /srv/docker/${NAME}/nginx/sites-enabled:/etc/nginx/sites-enabled ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

remove: 
	docker rm -f ${NAME} 

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
