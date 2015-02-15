FROM dajobe/base

MAINTAINER Dave Beckett <dave@dajobe.org>

COPY *.sh /build/

RUN /build/prepare-nghttp2.sh

RUN cd /build/nghttp2 && make install

RUN /build/cleanup-nghttp2.sh && rm -rf /build

RUN mkdir -p /data/etc /data/etc/ssl/certs /data/etc/ssl/private /data/logs /data/run

VOLUME /data

COPY nghttpx.conf /data/etc/nghttpx.conf

EXPOSE 80

EXPOSE 3000

CMD [ "/usr/bin/nghttpx", "--frontend-no-tls", "--conf", "/data/etc/nghttpx.conf" ]
