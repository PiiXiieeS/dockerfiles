.PHONY: all build run remove push

NAME=mahara
NAMESPACE=maxder
IMAGENAME=alpine

all: tag

tag:
	./scripts/architecture.sh
	${MAKE} build
	
build:  
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:x86_64 .

run:
	docker run -d --hostname ${NAME} --name ${NAME} -e INSTALL=silent --link mysql:db -p 8989:80 -v /srv/docker/${NAME}/data:/var/${NAME}/data ${NAMESPACE}/${IMAGENAME}-${NAME}:x86_64

remove:
	docker rm -f ${NAME} 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:x86_64
