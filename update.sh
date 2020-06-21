#!/bin/bash -x

if ! test -w /var/run/docker.sock; then
  SUDO=sudo
else
  SUDO=
fi

docker volume create apk-cache || true
docker volume create npm-cache || true
$SUDO docker run -i -t \
  -v npm-cache:/root/.npm/_cacache \
  -v apk-cache:/var/cache/apk \
  -v $PWD:/usr/share/verdaccio \
  -w /srv \
  $(sed -n -e 's/FROM //p' Dockerfile) sh -x -c '
set -e
apk add --no-cache alpine-conf
setup-apkcache /var/cache/apk
apk add --no-cache make nodejs npm python2
rm -f package-lock.json
cp /usr/share/verdaccio/package.json .
npm install verdaccio
cp package-lock.json /usr/share/verdaccio
'
