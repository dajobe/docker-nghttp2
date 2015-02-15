#!/bin/sh -x

. /build/config-nghttp2.sh

rm -rf /build/nghttp2

apt-get remove -y $NGHTTP2_BUILD_PACKAGES

apt-get autoremove -y

# Install the run-time dependencies
apt-get install $minimal_apt_get_args $NGHTTP2_RUN_PACKAGES

. /build/cleanup.sh
