.PHONY: build

NAME=bbb-freeswitch
NAMESPACE=maxder
IMAGENAME=ubuntu

build:
	$(MAKE) -C ../ffmpeg build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME} .
