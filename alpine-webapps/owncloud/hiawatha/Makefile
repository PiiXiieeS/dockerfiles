.PHONY: all build run remove push

NAME=owncloud
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
	
builddocker:
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

build:  tag
	${MAKE} builddocker

rundocker:
	docker run -d --hostname ${NAME} --name ${NAME} -e HOSTNAME=$(shell hostname) --link mariadb:db -e OCADMIN=ocadmin -e OCPASS=ocadmin -p 80:80 -v /srv/docker/${NAME}/hiawatha:/etc/hiawatha/sites-enabled -v /srv/docker/${NAME}/data:/var/${NAME}/data -v /srv/docker/${NAME}/config:/usr/share/webapps/${NAME}/config ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

run:	tag
	$(MAKE) rundocker

remove:
	docker rm -f ${NAME} 

push:	tag
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
