.PHONY: all build run push

NAME=hiawatha
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
	
builddocker:
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

build:  tag
	$(MAKE) builddocker
	
run:	
	$(MAKE) tag
	docker run --log-driver json-file --log-opt max-size=1k --log-opt max-file=10 -d --hostname ${NAME} --name ${NAME} -p 80:80 -p 443:443 -v /srv/docker/${NAME}/sites-enabled:/etc/hiawatha/sites-enabled -v /srv/docker/${NAME}/tls:/etc/hiawatha/tls ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
	docker logs ${NAME}

quickstart:
	$(MAKE) build
	$(MAKE) run

remove:
	docker rm -f ${NAME} 

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
