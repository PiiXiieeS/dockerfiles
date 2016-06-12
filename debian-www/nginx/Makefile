
.PHONY: all build run push

NAME=nginx
NAMESPACE=maxder
IMAGENAME=debian

all: build

build:
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME} .

run:
	docker run --log-driver json-file --log-opt max-size=1k --log-opt max-file=10 -d --hostname ${NAME} --name ${NAME} -p 80:80 -p 443:443 -v /srv/docker/${NAME}/tls:/etc/nginx/tls  -v /srv/docker/${NAME}/sites-enabled:/etc/nginx/sites-enabled ${NAMESPACE}/${IMAGENAME}-${NAME}

remove: 
	docker rm -f ${NAME} 

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}
