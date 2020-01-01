ARG from_image
FROM $from_image

ARG phpldapadmin_version

# Use the default production configuration
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install dependencies
RUN apt-get update && \
    apt-get install libldap2-dev -y && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install gettext ldap

# Install phpLDAPadmin
RUN mkdir -p /opt/phpldapadmin && \
    cd /opt/phpldapadmin && \
    curl -sL https://github.com/leenooks/phpLDAPadmin/archive/${phpldapadmin_version}.tar.gz | tar xz --strip-components=1 && \
    cp /opt/phpldapadmin/config/config.php.example /opt/phpldapadmin/config/config.php && \
    rm -Rf /var/www/html && \
    ln -s /opt/phpldapadmin/htdocs /var/www/html
