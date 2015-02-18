FROM dajobe/base

MAINTAINER Dave Beckett <dave@dajobe.org>

COPY *.sh /build/

RUN /build/prepare-nghttp2.sh

RUN cd /build/nghttp2 && make install

RUN /build/cleanup-nghttp2.sh && rm -rf /build

VOLUME /data

COPY nghttpx.conf /etc/nghttpx.conf

COPY start-nghttpx /usr/bin/start-nghttpx

EXPOSE 80

EXPOSE 3000

CMD [ "/usr/bin/start-nghttpx" ]
