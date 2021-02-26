#!/bin/bash -x

if ! test -w /var/run/docker.sock; then
  SUDO=sudo
else
  SUDO=
fi

if docker container inspect cache_cache_1 &>/dev/null; then
  cache=--volumes-from=cache_cache_1
else
  cache=
fi

$SUDO docker run \
  $cache \
  --volume $PWD:/srv \
  --workdir /usr/share/verdaccio \
  $(head -n1 Dockerfile | sed -n -e 's/FROM //p') sh -x -c "
set -e
apk add --no-cache alpine-conf
setup-apkcache /var/cache/apk
apk add --no-cache make nodejs npm python2
cp /srv/package.json .
npm install verdaccio
cp package-lock.json /srv
"
