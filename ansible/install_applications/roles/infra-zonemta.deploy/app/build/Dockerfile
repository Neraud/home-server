ARG from_image
FROM $from_image

ARG ZONE_MTA_VERSION

RUN apk add --update \
  make \
  python \
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
