#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

url='git://github.com/dajobe/docker-nghttp2'

echo '# maintainer: Dave Beckett <dave@dajobe.org> (@dajobe)'

commit="$(git log -1 --format='format:%H' -- .)"
fullVersion="$(grep -m1 'ENV NGHTTP2_VERSION ' Dockerfile | cut -d' ' -f3)"

versionAliases=()
while [ "${fullVersion%.*}" != "$fullVersion" ]; do
	versionAliases+=( $fullVersion )
	fullVersion="${fullVersion%.*}"
done
versionAliases+=( $fullVersion latest )

echo
for va in "${versionAliases[@]}"; do
	echo "$va: ${url}@${commit}"
done
