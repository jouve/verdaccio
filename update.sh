#!/bin/bash -x

docker run -v $PWD:/usr/src/verdaccio -w /usr/src/verdaccio $(sed -n -e 's/FROM //p' Dockerfile) sh -c 'apk add --no-cache make nodejs npm python && npm up'
