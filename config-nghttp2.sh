# This file intended to be sourced

# . /build/config.sh

# Prevent initramfs updates from trying to run grub and lilo.
export INITRD=no
export DEBIAN_FRONTEND=noninteractive

minimal_apt_get_args='-y --no-install-recommends'


# File containing original installed packages
PACKAGES_INSTALLED_LOG="/tmp/packages.lst"

# git clone URL
# NGHTTP2_CLONE_URL="https://github.com/tatsuhiro-t/nghttp2"
NGHTTP2_CLONE_URL="https://github.com/nghttp2/nghttp2"

# Prefix URL for releases
# NGHTTP2_RELEASES_URL="https://github.com/tatsuhiro-t/nghttp2/releases"
NGHTTP2_RELEASES_URL="https://github.com/nghttp2/nghttp2/releases"

## Build time dependencies ##

# git and ca-certificates is needed for git clone; not building
# alternate would be to download a release tarball with curl or wget
# xz-utils is needed for tar to uncompress an .xz tarball
NGHTTP2_BUILD_PACKAGES="git ca-certificates curl xz-utils"

# Core list from docs
# For applications:
#   * OpenSSL >= 1.1.1; or wolfSSL >= 5.7.0; or LibreSSL >= 3.8.1; or
#      aws-lc >= 1.19.0; or BoringSSL
#   * libev >= 4.11
#   * zlib >= 1.2.3
#   * libc-ares >= 1.7.5
# Optional:
#   * libxml2 >= 2.6.26 : -a option in nghttp
#   * libsystemd-dev >= 209 : systemd support
#   * libjansson-dev > 2.5 - for HPACK tools
#   * libevent-openssl >= 2.0.8 - examples
#   * jemalloc - mitigate heap fragmentation in long running server programs (recommended)
#   * cython python-dev - python bindings
#   * ruby-dev bison - ruby bindings
#   * libelf-dev
#   * libbrotli-dev >= 1.0.9 - for boringssl 8879 TLS cert compressions
#   * quictls ngtpc2 nghttp3 - experimental http/3
#   * libbpf-dev >= 0.7.0 - optional eBPF program to direct incoming QUIC UDP datagram (http3)
# Removed: automake autoconf autotools-dev libtool
NGHTTP2_BUILD_PACKAGES="$NGHTTP2_BUILD_PACKAGES g++ clang make binutils pkg-config zlib1g-dev libssl-dev libxml2-dev libev-dev libevent-dev libjemalloc-dev libc-ares-dev libsystemd-dev"


# Python 3 too
NGHTTP2_BUILD_PACKAGES="$NGHTTP2_BUILD_PACKAGES python3 python3-dev"


## Run time dependencies ##
#   openssl and python are needed for OCSP /usr/share/nghttp2/fetch-ocsp-response
NGHTTP2_RUN_PACKAGES="libev4 libevent-2.1 libevent-openssl-2.1 libjemalloc2 libxml2 zlib1g openssl python3 libc-ares2"

# apt-get remove --allow-remove-essential enters an infinite loop of
# pam errors with this package
#  login: because it depends on libpam*
PACKAGES_REMOVE_SKIP_REGEX='(libpam|login)'
