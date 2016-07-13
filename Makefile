.PHONY: build

VERSION=1.0
NAME=bigbluebutton
NAMESPACE=maxder

buildbase:
	docker build --rm --no-cache=true -t ${NAMESPACE}/${NAME}:${VERSION} .

buildbbb:
	docker run -d --hostname ${NAME} --name ${NAME} --cap-add SYS_PTRACE ${NAMESPACE}/${NAME}:${VERSION}
	docker exec -it ${NAME} bash -c "apt-get install -y --force-yes --assume-yes bigbluebutton"
	docker rm -f ${NAME}

build:  buildbase buildbbb

