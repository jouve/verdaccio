FROM alpine:3.8

WORKDIR /usr/src/verdaccio

COPY package.json package-lock.json ./

RUN apk add --no-cache make nodejs npm python && \
    npm ci && \
    apk del --no-cache make npm python

EXPOSE 4873

COPY config.yaml /root/.config/verdaccio/config.yaml

WORKDIR /srv

CMD ["/usr/src/verdaccio/node_modules/.bin/verdaccio", "-l", "0.0.0.0:4873"]
