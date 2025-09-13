# Commadn line tool
DOCKER=podman
# registry site 
REG_PREFIX=docker.io

# https://hub.docker.com/repository/docker/dajobe/nghttpx/general

IMAGE_NAME=dajobe/nghttpx
IMAGE_TAG=latest

NGHTTPX_VERSION=$(shell awk '/^ENV NGHTTPX_VERSION/ {print $3}' Dockerfile)

build:
	@echo "Building nghttpx image $(NGHTTPX_VERSION)"
	$(DOCKER) build -t $(IMAGE_NAME) .

# This won't work unless you have already set up the repository config
push:
	@echo "Pushing image to registries"
	$(DOCKER) push $(REG_PREFIX)/$(IMAGE_NAME):$(IMAGE_TAG)
