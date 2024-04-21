FROM docker.io/library/node:21.7.3-alpine3.19

ARG ZONE_MTA_VERSION=3.9.5

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
