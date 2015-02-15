#!/bin/sh
# This file intended to be sourced

. /build/config.sh

## Build time dependencies ##

# git is needed for cloning; not building
NGHTTP2_BUILD_PACKAGES="git"

# Core list from cocs
NGHTTP2_BUILD_PACKAGES="$NGHTTP2_BUILD_PACKAGES make binutils autoconf automake autotools-dev libtool pkg-config zlib1g-dev libssl-dev libxml2-dev libev-dev libevent-dev libjemalloc-dev"

# Optional:
#   libcunit1-dev - for tests
#   libjansson-dev - for HPACK tools
#   libjemalloc-dev - optional but recommended
#   cython python-dev - python bindings

# building the servers needs g++
NGHTTP2_BUILD_PACKAGES="$NGHTTP2_BUILD_PACKAGES g++"


## Run time dependencies ##
NGHTTP2_RUN_PACKAGES="libev4 libevent-2.0-5 libevent-openssl-2.0-5 libjemalloc1 libxml2 zlib1g"
