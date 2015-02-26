#!/bin/sh -x

. /build/config-nghttp2.sh

AUTO_ADDED_PACKAGES=`apt-mark showauto`

apt-get remove --purge -y $NGHTTP2_BUILD_PACKAGES $AUTO_ADDED_PACKAGES

# Install the run-time dependencies
apt-get install $minimal_apt_get_args $NGHTTP2_RUN_PACKAGES

# . /build/cleanup.sh
rm -rf /tmp/* /var/tmp/*

apt-get clean
rm -rf /var/lib/apt/lists/*
