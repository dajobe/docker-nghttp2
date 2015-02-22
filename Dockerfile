FROM debian:jessie

MAINTAINER Dave Beckett <dave@dajobe.org>

COPY *.sh /build/

RUN /build/prepare-nghttp2.sh && \
    cd /build/nghttp2 && make install && \
    rm -rf /build/nghttp2 && /build/cleanup-nghttp2.sh && rm -rf /build

VOLUME /data

COPY nghttpx.conf /etc/nghttpx.conf

COPY start-nghttpx /usr/bin/start-nghttpx

EXPOSE 3000

CMD [ "/usr/bin/start-nghttpx" ]
