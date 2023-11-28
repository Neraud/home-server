FROM docker.io/coudot/lemonldap-ng:2.17.2

# Copy plugins
COPY LoginFailedHeaderPlugin.pm /usr/share/perl5/Lemonldap/NG/Portal/

# Enable plugins
RUN sed -i 's/^;customPlugins *=.*/customPlugins = Lemonldap::NG::Portal::LoginFailedHeaderPlugin/' /etc/lemonldap-ng/lemonldap-ng.ini
