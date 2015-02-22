nghttp2 HTTP/2.0 proxy and client
=================================

This *unofficial* docker image provides HTTP/1.0 proxies and clients
from [nghttp2](https://github.com/tatsuhiro-t/nghttp2) by
[Tatsuhiro Tsujikawa](https://github.com/tatsuhiro-t):

* `nghttpx` HTTP/2.0 proxy sits in front of an existing HTTP/1.0
  server to provide support for HTTP/2.0 http or https URLs.
* `nghttp` HTTP/2.0 client can make HTTP/2.0 requests and show
  debugging info.

See [github](https://github.com/dajobe/docker/tree/master/nghttp2)
for the sources to this docker image.


Building Image
--------------

If you want to build the image yourself use this command:

    $ docker build -t dajobe/nghttpx .

The image is prebuilt and uploaded the Docker hub so you skip this
step and follow the next section.


Running Proxy Server
--------------------

The proxy runs and uses a volume `/data` that generally should be
mapped to a local data directory e.g `$PWD/data` to store logs and
configuration.

The proxy will write access and error logs to files below the the
`/data/logs` dir so it should appear in `$PWD/data/logs` if you use
the volume mappings suggested.  The default config file will be
written to `/data/etc/nghttpx.conf` if it doesn't exist; if it is
updated, it will not be replaced the next time the proxy is urn.

To run the proxy with HTTP/2.0 proxying to an HTTP/1.0 server, the
hostname and port of the HTTP/1.0 server (the _backend_) needs to
be given via the `HOST` and `PORT` (default 80) envariables:

    $ mkdir -p data
    $ docker run --name nghttpx -d -p 80:3000 -v $PWD/data:/data \
        -e HOST=192.168.1.2 -e PORT=12345 dajobe/nghttpx

To run with TLS/SSL HTTP/2.0 that can server an https url, put the
key file in `$PWD/data/etc/keyfile` and the certificate file in
`$PWD/data/etc/certfile` and set the `KEY_FILE` and `CERT_FILE`
envariable arguments like this:

    $ mkdir -p data
    $ docker run --name nghttpx -d -p 443:3000 -v $PWD/data:/data \
       -e HOST=192.168.1.2 -e PORT=12345 \
       -e KEY_FILE=/data/etc/keyfile CERT_FILE=/data/etc/certfile dajobe/nghttpx

Generally `HOST` should be set to a private IP address of the host
that docker is running on and a separate server such as apache or
nginx used to deliver a website over HTTP/1.0 on some `PORT` such as
12345 in the examples above.


Running Client
--------------

You can also run the `nghttp` client included in the image if you
want to test out HTTP/2.0:

    $ docker run --rm -it dajobe/nghttpx nghttp -v https://nghttp2.org/
	[  0.374] Connected
	[  0.633][NPN] server offers:
			  * h2
			  * h2-16
			  * h2-14
			  * spdy/3.1
			  * http/1.1
	The negotiated protocol: h2-16
    ...

(lots of output truncated)

See [the docs](https://github.com/tatsuhiro-t/nghttp2/blob/master/README.rst)
for details on how to use the client.

Alternately, the most recent Mozilla Firefox and Google Chrome
browsers support HTTP/2.0 over https although it may require some
configuration.

