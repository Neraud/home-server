FROM docker.io/homeassistant/home-assistant:2023.3.6

ADD entrypoint.sh /opt/entrypoint.sh

RUN echo "Installing ldap requirements" && \
        apk add --no-cache openldap-clients

ADD ldap-auth /opt/ldap-auth
RUN chmod +x /opt/ldap-auth/ldap-auth.sh

# TODO remove unused socat and supervisor

# Install supervision via pip to avoid bug : https://github.com/docker-library/python/issues/624
RUN echo "Installing socat and requirements" && \
        apk add --no-cache socat && \
        pip install supervisor==4.2.2

RUN mkdir -p /etc/supervisor/conf.d/
ADD supervisord.conf /etc/supervisor/

RUN echo "Creating homeassistant user" && \
        addgroup -g 1000 homeassistant && \
        adduser -u 1000 -G homeassistant -s /bin/sh -D homeassistant

RUN echo "Install and configure sudo fo socat" && \
        apk add --no-cache sudo && \
        echo "homeassistant ALL=(ALL) NOPASSWD: /usr/bin/socat" >> /etc/sudoers

USER homeassistant

CMD [ "sh", "/opt/entrypoint.sh" ]
