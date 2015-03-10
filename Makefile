NGHTTP2_VERSION=$(awk '/^ENV NGHTTP2_VERSION/ {print $3}' Dockerfile)

build:
	@echo "Building nghttp $$NGHTTP2_VERSION"
	docker build -t dajobe/nghttpx .
