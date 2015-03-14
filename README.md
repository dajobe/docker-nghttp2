nghttp2 HTTP/2.0 proxy and client docker image
==============================================

This *unofficial* docker image provides HTTP/2.0 proxies and clients
from [nghttp2](https://github.com/tatsuhiro-t/nghttp2) by
[Tatsuhiro Tsujikawa](https://github.com/tatsuhiro-t):

* `nghttpx` HTTP/2.0 proxy that can work in front of an existing
  HTTP/1.0 server to provide support for HTTP/2.0 http or https URLs.
* `nghttp` HTTP/2.0 client to make HTTP/2.0 requests and show
  debugging info.

See [github](https://github.com/dajobe/docker-nghttp2/)
for the sources to this docker image.


Building the docker image
-------------------------

If you want to build the image yourself use this command:

    $ docker build -t dajobe/nghttpx .

The image is prebuilt and uploaded the Docker hub so you skip this
step and follow the next section.


Running the nghttpx HTTP/2.0 Proxy Server
-----------------------------------------

The proxy runs and uses a volume `/data` that generally should be
mapped to a local data directory e.g `$PWD/data` to store logs and
configuration.

The proxy will write access and error logs to files below the the
`/data/logs` dir so it should appear in `$PWD/data/logs` if you use
the volume mappings suggested.  The default config file will be
written to `/data/etc/nghttpx.conf` if it doesn't exist; if it is
updated, it will not be replaced the next time the proxy is urn.

To run the proxy with non-encrypted HTTP/2.0 on port 80 that can
serve an http url, proxying to an HTTP/1.0 server, the hostname and
port of the HTTP/1.0 server (the _backend_ ) needs to be given via
the `HOST` and `PORT` envariables:

    $ mkdir -p data
    $ docker run --name nghttpx -d -p 80:3000 -v $PWD/data:/data \
        -e HOST=192.168.1.2 -e PORT=12345 \
        dajobe/nghttpx

To run the proxy with TLS/SSL HTTP/2.0 on port 443 that can serve an
https url, in addition to the host and port config above you will
need to put the server TLS/SSL key file in `$PWD/data/etc/keyfile`
and the certificate file in `$PWD/data/etc/certfile` and set the
`KEY_FILE` and `CERT_FILE` envariable arguments to those paths like
this:

    $ mkdir -p data
    $ docker run --name nghttpx -d -p 443:3000 -v $PWD/data:/data \
       -e HOST=192.168.1.2 -e PORT=12345 \
       -e KEY_FILE=/data/etc/keyfile CERT_FILE=/data/etc/certfile \
       dajobe/nghttpx

Generally `HOST` should be set to a private IP address of the host
that `docker(1)` is running on and a separate server such as Apache
or Nginx used to deliver a website over HTTP/1.0 on the `PORT` such
as 12345 in the examples above.

To stop the server container in either case above use:

    $ docker stop nghttpx

and to delete the container (which won't lose the data and logs,
since they are in `$PWD/data`) use:

    $ docker rm nghttpx

If you want to run *both* the http (port 80) and https (port 443)
HTTP/2.0 proxies, you can do that but you will need to run two
servers with separate data dirs and configurations since the proxy
runs in only one mode ( via the `--frontend-no-tls` flag to nghttpx ).
You will also need to give the containers different names with
the `--name` option to the `docker(1)` command

Finally the envariable `ARGS` can be used to set any additional proxy
runtime args that may be required.  Creating a custom config file at
`$PWD/data/etc/nghttpx.conf` as describe above is an alternative.


Running the nghttp HTTP/2.0 Client
----------------------------------

You can also run the `nghttp` client included in the image if you
want to test out HTTP/2.0:

    $ docker run --rm -it dajobe/nghttpx nghttp -v https://nghttp2.org/
	[  0.246] Connected
	[  0.360][NPN] server offers:
			  * h2
			  * h2-16
			  * h2-14
			  * spdy/3.1
			  * http/1.1
    The negotiated protocol: h2
    ...

(lots of output truncated)

See [the docs](https://github.com/tatsuhiro-t/nghttp2/blob/master/README.rst)
for details on how to use the client.

Alternately, the most recent Mozilla Firefox and Google Chrome
browsers support HTTP/2.0 over https although it may require some
configuration.

