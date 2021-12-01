FROM alpine:3.15.0

WORKDIR /usr/src/verdaccio

COPY package.json package-lock.json ./

RUN apk add --no-cache make nodejs-current npm python2 && \
    npm ci && \
    apk del --no-cache make npm python2

EXPOSE 4873

COPY config.yaml /root/.config/verdaccio/config.yaml

WORKDIR /var/lib/verdaccio

CMD ["/usr/src/verdaccio/node_modules/.bin/verdaccio", "-l", "0.0.0.0:4873"]
