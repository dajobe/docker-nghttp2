#!/bin/sh -x

. /build/config-nghttp2.sh

apt-get update -y

apt-get install $minimal_apt_get_args $NGHTTP2_BUILD_PACKAGES

cd /build

if test -n "$VERSION"; then
  curl -SL https://github.com/tatsuhiro-t/nghttp2/releases/download/v$VERSION/nghttp2-$VERSION.tar.xz | tar -x -J && mv nghttp2-$VERSION nghttp2
else
  git clone https://github.com/tatsuhiro-t/nghttp2
fi

cd nghttp2

if test ! -r "configure"; then
  autoreconf -i
  automake
  autoconf
fi

./configure --enable-app --disable-hpack-tools --disable-examples \
	    --prefix=/usr
