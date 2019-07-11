ARG from_image
FROM $from_image

ADD entrypoint.sh /opt/entrypoint.sh

ADD ldap-auth /opt/ldap-auth
RUN chmod +x /opt/ldap-auth/ldap-auth.sh

RUN echo "Installing socat" && \
        chmod -R 777 /tmp && \
        apt-get update && \
        apt-get install -y socat && \
        echo "Cleaning" && \
        apt-get clean && \
        rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

CMD [ "sh", "/opt/entrypoint.sh" ]
