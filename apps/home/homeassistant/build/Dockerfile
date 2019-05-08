FROM homeassistant/home-assistant:0.89.2

ADD entrypoint.sh /opt/entrypoint.sh

ADD ldap-auth /opt/ldap-auth
RUN chmod +x /opt/ldap-auth/ldap-auth.sh

CMD [ "sh", "/opt/entrypoint.sh" ]
