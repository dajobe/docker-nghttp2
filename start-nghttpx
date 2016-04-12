#!/bin/sh
# Start nghttpx HTTP/2 proxy with ability to set backend, TLS/SSL
# config and extra runtime args

cert_args=""
args=""
if test -n "$HOST"; then
    if test -z "$PORT"; then
       PORT=80
    fi
    args="$args --backend=$HOST,$PORT"
fi
if test -n "$KEY_FILE" -a -n "$CERT_FILE"; then
    cert_args="$KEY_FILE $CERT_FILE"
else
    args="$args --frontend=*,3000;no-tls"
fi
if test -n "$ARGS"; then
    args="$args $ARGS"
fi

mkdir -p /data/etc /data/etc/ssl/certs /data/etc/ssl/private /data/logs /data/run

if test ! -r /data/etc/nghttpx.conf; then
  cp /etc/nghttpx.conf /data/etc/nghttpx.conf
fi

echo "exec /usr/bin/nghttpx --conf /data/etc/nghttpx.conf $args $cert_args"

exec /usr/bin/nghttpx --conf /data/etc/nghttpx.conf $args $cert_args
