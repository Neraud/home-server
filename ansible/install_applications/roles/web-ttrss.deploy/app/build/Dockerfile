ARG from_image
FROM $from_image

ARG ttrss_commit
ARG ttrss_plugin_data_migration_url
ARG ttrss_plugin_auth_ldap_url
ARG ttrss_plugin_mailer_smtp_url

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
ENV APACHE_PID_FILE /tmp/apache2/run/apache2.pid
ENV APACHE_RUN_DIR /tmp/apache2/run/
ENV APACHE_LOCK_DIR /tmp/apache2/lock/

# Inject an optional Apache2 configuration folder
RUN echo "IncludeOptional /tmp/apache2/conf/*.conf" > /etc/apache2/conf-available/custom.conf && \
    a2enconf custom

# Install php extensions
RUN apt-get update && \
    apt-get install -y libicu-dev && \
    docker-php-ext-install intl && \
    apt-get install -y zlib1g-dev libpng-dev && \
    docker-php-ext-install gd && \
    apt-get install -y libpq-dev && \
    docker-php-ext-install pgsql pdo_pgsql && \
    docker-php-ext-install opcache && \
    docker-php-ext-install pcntl && \
    rm -rf /var/lib/apt/lists/*

# Install TTRSS
RUN mkdir -p /opt/ttrss && \
    curl -sL "https://git.tt-rss.org/fox/tt-rss/archive/${ttrss_commit}.tar.gz" | tar xz --strip-components=1 -C /opt/ttrss && \
    rm -Rf /var/www/html && \
    ln -s /opt/ttrss /var/www/html && \
    chown -R www-data:www-data /opt/ttrss && \
    chown -R www-data:www-data /var/www

ENV TTRSS_RUN_ROOT_DIR=/opt/ttrss

# Prepare apache conf for alias if needed
RUN touch /etc/apache2/conf-enabled/ttrss-context.conf && \
    chown www-data:www-data /etc/apache2/conf-enabled/ttrss-context.conf

ADD entrypoint.sh /opt/
RUN chown www-data:www-data /opt/entrypoint.sh && \
    chmod 744 /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["web"]

# Install plugin data migration
RUN apt-get update && \
    apt-get install -y zlib1g-dev libzip-dev && \
    docker-php-ext-install zip && \
    mkdir /opt/ttrss/plugins.local/data_migration && \
    curl -sL "${ttrss_plugin_data_migration_url}" | tar xz --strip-components=1 -C /opt/ttrss/plugins.local/data_migration && \
    rm -rf /var/lib/apt/lists/*

# Install plugin LDAP Auth
RUN apt-get update && \
    apt-get install -y libldap2-dev && \
    docker-php-ext-install ldap && \
    curl -sL "${ttrss_plugin_auth_ldap_url}" | tar xz --strip-components=2 -C /opt/ttrss/plugins.local && \
    rm -rf /var/lib/apt/lists/*

# Install plugin Mailer SMTP
RUN mkdir /opt/ttrss/plugins.local/mailer_smtp && \
    curl -sL "${ttrss_plugin_mailer_smtp_url}" | tar xz --strip-components=1 -C /opt/ttrss/plugins.local/mailer_smtp

USER www-data
