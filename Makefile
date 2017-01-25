IMAGE_NAME=dajobe/nghttpx
IMAGE_TAG=latest

NGHTTPX_VERSION=$(shell awk '/^ENV NGHTTPX_VERSION/ {print $3}' Dockerfile)

build:
	@echo "Building nghttpx docker image $(NGHTTPX_VERSION)"
	docker build -t $(IMAGE_NAME) .

# This won't work unless you have already set up the repository config
push:
	@echo "Pushing image to https://hub.docker.com/"
	docker push $(IMAGE_NAME):$(IMAGE_TAG)
