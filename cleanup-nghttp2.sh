#!/bin/bash -x

. /build/config-nghttp2.sh

# Remove auto added packages beyond those from base install
tmp=$(mktemp)
dpkg --get-selections | awk '{print $1}' | sort > "$tmp"
echo "Installed packages at end"
cat "$tmp"
packages_to_remove=$(comm -23 "$tmp" "$PACKAGES_INSTALLED_LOG")
#  | grep -vE "$PACKAGES_REMOVE_SKIP_REGEX"
rm -f "$tmp"

apt-get remove --purge -y --allow-remove-essential $packages_to_remove

# Install the run-time dependencies
apt-get install $minimal_apt_get_args $NGHTTP2_RUN_PACKAGES

# . /build/cleanup.sh
rm -rf /tmp/* /var/tmp/*

apt-get clean
rm -rf /var/lib/apt/lists/*
