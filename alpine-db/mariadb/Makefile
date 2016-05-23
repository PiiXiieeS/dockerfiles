.PHONY: all build run push

NAME=mariadb
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
	docker run -d --hostname ${NAME} --name ${NAME} -p 127.0.0.1:3306:3306 -e DBUSER="dbadmin" -e DBPASS="dbadminpass" -v /srv/docker/mysql:/var/lib/mysql ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

quickstart: 
	$(MAKE) tag
	$(MAKE) build
	$(MAKE) run

remove:
	docker rm -f ${NAME}

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
