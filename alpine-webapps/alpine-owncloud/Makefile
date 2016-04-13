.PHONY: all build run remove push

NAME=owncloud
NAMESPACE=maxder
IMAGENAME=alpine

all: tag

tag:
	./scripts/architecture.sh
	make build
	
build:  
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:
	docker run -d --hostname ${NAME} --name ${NAME} --link mysql:db -e OCADMIN=ocadmin -e OCPASS=ocadmin -p 80:80 -v /srv/docker/owncloud/data:/var/owncloud/data -v /srv/docker/owncloud/config:/usr/share/webapps/owncloud/config ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

remove:
	docker rm -f ${NAME} 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
