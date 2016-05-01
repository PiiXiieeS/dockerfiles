.PHONY: all build run push

NAME=nginx
NAMESPACE=maxder
IMAGENAME=alpine

all: tag

tag:
	./scripts/architecture.sh
	
build:  tag
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:	tag
	docker run -d --hostname ${IMAGENAME}-${NAME} --name ${IMAGENAME}-${NAME} -p 80:80 -v /srv/docker/nginx/sites-enabled:/etc/nginx/sites-enabled ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

remove: tag
	docker rm -f ${IMAGENAME}-${NAME} 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
