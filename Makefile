# Commadn line tool
DOCKER=podman
# registry site 
REG_PREFIX=docker.io

# https://hub.docker.com/repository/docker/dajobe/nghttpx/general

IMAGE_NAME=dajobe/nghttpx
IMAGE_TAG=latest

NGHTTP2_VERSION=$(shell awk '/^ENV NGHTTP2_VERSION/ {print $$3}' Dockerfile)

build:
	@echo "Building nghttpx image $(NGHTTP2_VERSION)"
	$(DOCKER) build -t $(IMAGE_NAME) .

# This won't work unless you have already set up the repository config
push:
	@echo "Pushing image to registries"
	$(DOCKER) tag localhost/$(IMAGE_NAME):$(IMAGE_TAG) $(REG_PREFIX)/$(IMAGE_NAME):$(IMAGE_TAG)
	$(DOCKER) push $(REG_PREFIX)/$(IMAGE_NAME):$(IMAGE_TAG)
