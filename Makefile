VERSION=$(awk '/^ENV VERSION/ {print $3}' Dockerfile)

build:
	@echo "Building nghttp $$VERSION"
	docker build -t dajobe/nghttpx .
