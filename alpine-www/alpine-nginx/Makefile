.PHONY: all build run push

NAME=nginx
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
	
build:  tag
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:	tag
	docker run -d --hostname ${NAME} --name ${NAME} -p 80:80 -v /srv/docker/${NAME}/sites-enabled:/etc/${NAME}/sites-enabled ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

remove: 
	docker rm -f ${NAME} 

push:	tag
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
