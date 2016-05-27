
.PHONY: all build run remove push

NAME=etherpad
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
        
builddocker:
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

build:	tag
	$(MAKE) builddocker

rundocker:
	docker run -d --hostname ${NAME} --name ${NAME} --link mariadb:db -p 9001:9001 ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

run:	tag
	$(MAKE) rundocker

quickstart: build run

remove:
	docker rm -f ${NAME} 

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
