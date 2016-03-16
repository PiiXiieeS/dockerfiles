.PHONY: all build run remove push

NAME=php-fpm
NAMESPACE=maxder
IMAGENAME=alpine

all: tag

tag:
	./scripts/architecture.sh
	make build
	
build:  
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:
	docker run -d --hostname ${IMAGENAME}-${NAME} --name ${IMAGENAME}-${NAME} -p 127.0.0.1:9000:9000 ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

remove:
	docker rm -f ${IMAGENAME}-${NAME} 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
