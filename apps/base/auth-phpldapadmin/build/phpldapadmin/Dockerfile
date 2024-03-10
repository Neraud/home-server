# phpldapadmin 1.2.5 doesn't support PHP 7.4
FROM docker.io/library/php:7.3.33-apache-buster

# Change apache port
RUN sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/g' /etc/apache2/sites-enabled/000-default.conf
EXPOSE 8080

# Use the default production configuration
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Use a dedicated volume for all run or tmp files
# php sessions are already stored under /tmp by default
VOLUME [ "/tmp" ]
# Change Apache run paths
ENV APACHE_PID_FILE /tmp/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /tmp/run/apache2
ENV APACHE_LOCK_DIR /tmp/lock/apache2

# Install dependencies
RUN apt-get update && \
    apt-get install libldap2-dev -y && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install gettext ldap

# Install phpLDAPadmin
RUN mkdir -p /opt/phpldapadmin && \
    cd /opt/phpldapadmin && \
    curl -sL https://github.com/leenooks/phpLDAPadmin/archive/1.2.6.7.tar.gz | tar xz --strip-components=1 && \
    cp /opt/phpldapadmin/config/config.php.example /opt/phpldapadmin/config/config.php && \
    rm -Rf /var/www/html && \
    ln -s /opt/phpldapadmin/htdocs /var/www/html

USER www-data

