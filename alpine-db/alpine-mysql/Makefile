.PHONY: all build run push

NAME=mysql
NAMESPACE=maxder
IMAGENAME=alpine

all: tag

tag:
	./scripts/architecture.sh
	$(MAKE) build
	
build:  
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:
	rand=$$(date +%s | sha256sum | base64 | head -c 32 ; echo)
	docker run -d --hostname ${NAME} --name ${NAME} -p 127.0.0.1:3306:3306 -e DBUSER="dbadmin" -e DBPASS="$$rand" ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

remove:
	docker rm -f ${NAME}

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
