FROM docker.io/lemonldapng/lemonldap-ng:2.20.2

# Copy plugins
COPY LoginFailedHeaderPlugin.pm /usr/share/perl5/Lemonldap/NG/Portal/

# Enable plugins
RUN sed -i 's/^;customPlugins *=.*/customPlugins = Lemonldap::NG::Portal::LoginFailedHeaderPlugin/' /etc/lemonldap-ng/lemonldap-ng.ini

# Workaround for issue: https://github.com/LemonLDAPNG/lemonldap-ng-docker/issues/65
COPY docker-entrypoint.sh /
