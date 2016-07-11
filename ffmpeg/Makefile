.PHONY: build

NAME=bbb-ffmpeg
NAMESPACE=maxder
IMAGENAME=ubuntu

build:
	$(MAKE) -C ../base build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME} .
