.PHONY: all build run remove push

NAME=humhub
NAMESPACE=maxder
IMAGENAME=alpine

all: tag

tag:
	./scripts/architecture.sh
	make build
        
build:
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:
	docker run -d --hostname ${NAME} --name ${NAME} --link mysql:db -p 8080:80 ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

remove:
	docker rm -f ${NAME} 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
