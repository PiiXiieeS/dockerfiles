.PHONY: all build run remove push

NAME=php-fpm
NAMESPACE=maxder
IMAGENAME=alpine

all: tag

tag:
	./scripts/architecture.sh
	
build:  tag
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:	tag
	docker run -d --hostname ${NAME} --name ${NAME} -p 127.0.0.1:9000:9000 -p 80:80 -v /srv/docker/${NAME}/nginx/sites-enabled:/etc/nginx/sites-enabled ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

remove: 
	docker rm -f ${NAME} 

push:	tag
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
