FROM ghcr.io/home-assistant/home-assistant:2025.10.4

ADD entrypoint.sh /opt/entrypoint.sh

RUN echo "Installing ldap requirements" && \
        apk add --no-cache openldap-clients

ADD ldap-auth /opt/ldap-auth
RUN chmod +x /opt/ldap-auth/ldap-auth.sh

RUN echo "Creating homeassistant user" && \
        addgroup -g 1000 homeassistant && \
        adduser -u 1000 -G homeassistant -s /bin/sh -D homeassistant

USER homeassistant

CMD [ "sh", "/opt/entrypoint.sh" ]
