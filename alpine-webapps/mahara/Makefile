.PHONY: all build run remove push

NAME=mahara
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
	
build:  tag
	docker build --rm  --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:	tag
	docker run -d --hostname ${NAME} --name ${NAME} -e INSTALL=silent --link mysql:db -p 80:80 -v /srv/docker/${NAME}/data:/var/${NAME}/data ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

remove:
	docker rm -f ${NAME} 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
