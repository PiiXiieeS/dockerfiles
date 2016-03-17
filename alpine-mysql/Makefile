.PHONY: all build run push

NAME=mysql
NAMESPACE=maxder
IMAGENAME=alpine

all: tag

tag:
	./scripts/architecture.sh
	make build
	
build:  
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:armhf .

run:
	rand=$$RANDOM && \
	docker run -d --hostname ${NAME} --name ${NAME} -p 127.0.0.1:3306:3306 -e DBUSER="dbadmin" -e DBPASS="$$rand" ${NAMESPACE}/${IMAGENAME}-${NAME}:armhf

remove:
	docker rm -f ${IMAGENAME}-${NAME}

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:armhf
