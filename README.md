nghttp2 HTTP/2 proxy
====================

build:

    docker build -t dajobe/nghttpx .

To run it, the hostname and port of the HTTP/1.0 server that it is
proxying to need to be given via the `HOST` and `PORT` (default 80)
envariables:

    $ docker run --name nghttpx -d -p 3000:3000 -v $PWD/data:/data -e HOST=192.168.1.2 -e PORT=12345  dajobe/nghttpx

