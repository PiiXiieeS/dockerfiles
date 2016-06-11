.PHONY: all build push

NAME=base
NAMESPACE=maxder
IMAGENAME=debian

all: build
	
build:  
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME} .

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}

