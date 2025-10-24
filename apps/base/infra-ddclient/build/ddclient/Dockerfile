FROM docker.io/library/alpine:3.22.2

ENV DDCLIENT_CONFIG_PATH=/tmp/ddclient.conf
ENV DDCLIENT_CONF_DAEMON=1800
ENV DDCLIENT_CONF_VERBOSE=yes
ENV DDCLIENT_CONF_SSL=yes
ENV DDCLIENT_CONF_WEB=ipify-ipv4
ENV DDCLIENT_CONF_PROTOCOL=dyndns2
#ENV DDCLIENT_CONF_SERVER
#ENV DDCLIENT_CONF_LOGIN
#ENV DDCLIENT_CONF_PASSWORD
#ENV DDCLIENT_CONF_HOST=my.domain1.tld,my.domaine2.tld

RUN apk add --no-cache bash ddclient

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ddclient

ENTRYPOINT [ "/entrypoint.sh" ]
