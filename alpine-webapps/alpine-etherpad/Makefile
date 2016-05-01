
.PHONY: all build run remove push

NAME=etherpad
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
        
build:	tag
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:	tag
	docker run -d --hostname ${NAME} --name ${NAME} --link mysql:db -p 9001:9001 ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

remove:
	docker rm -f ${NAME} 

push:	tag
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
