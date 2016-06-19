.PHONY: all build run push

NAME=mariadb
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
	
builddocker:  
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:armhf .
	
build:  tag
	$(MAKE) builddocker
	
rundicker:
	docker run -d --hostname ${NAME} --name ${NAME} -p 127.0.0.1:3306:3306 -e DBUSER="dbadmin" -e DBPASS="dbadminpass" -v /srv/docker/mysql:/var/lib/mysql ${NAMESPACE}/${IMAGENAME}-${NAME}:armhf

run:	tag
	$(MAKE) rundocker

quickstart: build run

remove:
	docker rm -f ${NAME}

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:armhf
