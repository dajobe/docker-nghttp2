#!/bin/bash -x

. /build/config-nghttp2.sh

apt-get update -y

dpkg --get-selections | awk '{print $1}' | sort > "$PACKAGES_INSTALLED_LOG"
echo "Installed packages at start"
cat "$PACKAGES_INSTALLED_LOG"

apt-get install $minimal_apt_get_args $NGHTTP2_BUILD_PACKAGES

cd /build || exit

if test -n "$NGHTTP2_VERSION"; then
  curl -SL "https://github.com/tatsuhiro-t/nghttp2/releases/download/v${NGHTTP2_VERSION}/nghttp2-${NGHTTP2_VERSION}.tar.xz" | tar -x -J && mv "nghttp2-${NGHTTP2_VERSION}" nghttp2
else
  git clone https://github.com/tatsuhiro-t/nghttp2
fi

cd nghttp2 || exit

#if test ! -r "configure"; then
  # python 3.8 needed from 2020-12-29 commit 22af8e78 => version 1.43.0
  # debian buster only has 3.7
  # which is good enough, so switch default to 3.7
  sed -i~ -e "s/AM_PATH_PYTHON.*/AM_PATH_PYTHON([3.7],, [:])/" \
          -e "s/AX_PYTHON_DEVEL.*/AX_PYTHON_DEVEL([>= '3.7'])/" \
      configure.ac

  # Confirm changed lines
  grep -E 'AM_PATH_PYTHON|AX_PYTHON_DEVEL' configure.ac

  autoreconf -i
  automake
  autoconf
#fi

./configure --enable-app --disable-hpack-tools --disable-examples \
	    --prefix=/usr
