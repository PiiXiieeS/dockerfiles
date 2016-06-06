.PHONY: all build run remove push

NAME=hiawatha-php7
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
	
builddocker:  
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

build:  tag
	$(MAKE) builddocker

rundocker:
	docker run -d --hostname ${NAME} --name ${NAME} -e HOSTNAME=$(shell hostname) -p 80:80 -p 443:443 -v /srv/docker/${NAME}/config:/etc/hiawatha/config -v /srv/docker/${NAME}/tls:/etc/hiawatha/tls -v /srv/docker/${NAME}/sites-enabled:/etc/hiawatha/sites-enabled -v /srv/docker/${NAME}/webapps:/usr/share/webapps ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

run:	tag
	$(MAKE) rundocker

quickstart: build run
	sleep 2
	docker logs ${NAME}

remove: 
	docker rm -f ${NAME} 

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
