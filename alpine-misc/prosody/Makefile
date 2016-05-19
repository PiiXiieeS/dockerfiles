.PHONY: all build run push

NAME=prosody
NAMESPACE=maxder
IMAGENAME=alpine

all: build

tag:
	./scripts/architecture.sh
	
build:  tag
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG .

run:	tag
	docker run -d --hostname ${NAME} --name ${NAME} -p 5222:5222 -p 5269:5269 -p 127.0.0.1:5347:5347 -v /srv/docker/prosody/config:/etc/prosody/config -v /srv/docker/prosody/certs:/etc/prosody/certs -v /srv/docker/prosody/logs:/var/log/prosody -v /srv/docker/prosody/modules:/usr/lib/prosody-modules ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG

remove:
	docker rm -f ${NAME}

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:ARCHTAG
