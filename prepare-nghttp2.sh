#!/bin/bash -x

. /build/config-nghttp2.sh

apt-get update -y

dpkg --get-selections | awk '{print $1}' | sort > "$PACKAGES_INSTALLED_LOG"
echo "Installed packages at start"
cat "$PACKAGES_INSTALLED_LOG"

apt-get install $minimal_apt_get_args $NGHTTP2_BUILD_PACKAGES

cd /build || exit

if test -n "$NGHTTP2_VERSION"; then
  curl -SL "${NGHTTP2_RELEASES_URL}/download/v${NGHTTP2_VERSION}/nghttp2-${NGHTTP2_VERSION}.tar.xz" | tar -x -J && mv "nghttp2-${NGHTTP2_VERSION}" nghttp2
else
  git clone "${NGHTTP2_CLONE_URL}"
fi

cd nghttp2 || exit

# --enable-http3 requires multiple extra dependencies
./configure --enable-app --disable-hpack-tools --disable-examples \
	    --prefix=/usr
