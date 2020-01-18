ARG from_image
FROM $from_image

ARG ttrss_commit

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

# Install php extensions
RUN apt-get update && \
    apt-get install -y libicu-dev && \
    docker-php-ext-install intl && \
    apt-get install -y zlib1g-dev libpng-dev && \
    docker-php-ext-install gd && \
    apt-get install -y libpq-dev && \
    docker-php-ext-install pgsql pdo_pgsql && \
    docker-php-ext-install opcache && \
    rm -rf /var/lib/apt/lists/*

# Install TTRSS
RUN mkdir -p /opt/ttrss && \
    curl -sL "https://git.tt-rss.org/fox/tt-rss/archive/${ttrss_commit}.tar.gz" | tar xz --strip-components=1 -C /opt/ttrss && \
    rm -Rf /var/www/html && \
    ln -s /opt/ttrss /var/www/html && \
    chown -R www-data:www-data /opt/ttrss && \
    chown -R www-data:www-data /var/www

ADD entrypoint.sh /opt/
RUN chown www-data:www-data /opt/entrypoint.sh && \
    chmod 744 /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]

# Install plugin LDAP Auth
RUN apt-get update && \
    apt-get install -y libldap2-dev && \
    docker-php-ext-install ldap && \
    curl -sL "https://github.com/hydrian/TTRSS-Auth-LDAP/archive/52e452cc97b5101dc6d9e911462fe5e161197930.tar.gz" | tar xz --strip-components=2 -C /opt/ttrss/plugins.local && \
    rm -rf /var/lib/apt/lists/*

# Install plugin LDAP Auth Mailer SMTP
RUN mkdir /opt/ttrss/plugins.local/mailer_smtp && \
    curl -sL "https://git.tt-rss.org/fox/ttrss-mailer-smtp/archive/eebc18f00ef5fbaebd4f9a6e43685f87ba8b537f.tar.gz" | tar xz --strip-components=1 -C /opt/ttrss/plugins.local/mailer_smtp

USER www-data
