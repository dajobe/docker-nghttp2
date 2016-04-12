NGHTTP2_VERSION=$(shell awk '/^ENV NGHTTP2_VERSION/ {print $3}' Dockerfile)

build:
	@echo "Building nghttpx $(NGHTTP2_VERSION)"
	docker build -t dajobe/nghttpx .
