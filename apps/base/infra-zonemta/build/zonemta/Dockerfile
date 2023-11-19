FROM docker.io/library/node:21.2.0-alpine3.18

ARG ZONE_MTA_VERSION=3.6.13

RUN apk add --update \
  make \
  && rm -rf /var/cache/apk/

RUN mkdir -p /opt/zone-mta && chown -R node:node /opt/zone-mta

USER node
WORKDIR /opt/zone-mta
COPY package.json /opt/zone-mta
COPY index.js /opt/zone-mta
COPY plugins /opt/zone-mta/plugins

RUN sed -i -r "s/ZONE_MTA_VERSION/${ZONE_MTA_VERSION}/g" /opt/zone-mta/package.json
RUN npm install --production

# 3.3.0+ (until 3.4.1 at least) crashes when a /metrics request is received : https://github.com/zone-eu/zone-mta/issues/291
# Workaround from the issue :
RUN sed -i \
  -e "s|this.server.get('/metrics', (req, res, next) => {|this.server.get('/metrics', async (req, res, next) => {|" \
  -e "s|promClient.register|await promClient.register|" \
  -e "s|this.server.use(restify.plugins.gzipResponse());|//this.server.use(restify.plugins.gzipResponse());|" \
  /opt/zone-mta/node_modules/zone-mta/lib/api-server.js

CMD ["node", "index.js", "--config=config/zonemta.toml"]
