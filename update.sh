#!/bin/bash -x

if [ "$(basename "$(readlink -f "$(which docker)")")" != podman ]; then
  if ! test -w /var/run/docker.sock; then
    SUDO=sudo
  else
    SUDO=
  fi
fi

if docker container inspect cache-cache-1 &>/dev/null; then
  cache=--volumes-from=cache-cache-1
else
  cache=
fi

$SUDO docker run \
  $cache \
  --volume $PWD:/srv \
  --volume /usr/share/verdaccio \
  --workdir /usr/share/verdaccio \
  $(head -n1 Dockerfile | sed -n -e 's/FROM //p') sh -x -c "
set -e
apk add --no-cache alpine-conf
setup-apkcache /var/cache/apk
apk add --no-cache nodejs-current npm
cp /srv/package.json .
npm install --package-lock-only
cp package-lock.json /srv
"
