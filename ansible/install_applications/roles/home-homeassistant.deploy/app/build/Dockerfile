ARG from_image
FROM $from_image

ADD entrypoint.sh /opt/entrypoint.sh

RUN echo "Installing ldap requirements" && \
        apk add --no-cache openldap-clients

ADD ldap-auth /opt/ldap-auth
RUN chmod +x /opt/ldap-auth/ldap-auth.sh

RUN echo "Installing socat and requirements" && \
        apk add --no-cache supervisor socat

RUN mkdir -p /etc/supervisor/conf.d/
ADD supervisord.conf /etc/supervisor/

CMD [ "sh", "/opt/entrypoint.sh" ]
