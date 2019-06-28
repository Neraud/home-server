FROM coudot/lemonldap-ng:2.0.3

# Copy plugins
COPY LoginFailedHeaderPlugin.pm /usr/share/perl5/Lemonldap/NG/Portal/

# Enable plugins
RUN sed -i 's/^;customPlugins *=.*/customPlugins = Lemonldap::NG::Portal::LoginFailedHeaderPlugin/' /etc/lemonldap-ng/lemonldap-ng.ini
