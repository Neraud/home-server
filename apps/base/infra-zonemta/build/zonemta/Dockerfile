FROM docker.io/library/node:23.11.1-alpine3.22
# Zone MTA 3.10.2 fails to start on node:24.6.0-alpine3.22
# Error: No such module: http_parser

ARG ZONE_MTA_VERSION=3.10.2

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

CMD ["node", "index.js", "--config=config/zonemta.toml"]
