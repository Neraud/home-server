ARG from_image
FROM $from_image

ARG app_tasks_repo
ARG app_tasks_version

# Use nextcloud sources as docroot
# Backup folders that are replaced by a volume
RUN mkdir /usr/src/nextcloud_bak && \
    chown -R nobody:nogroup /usr/src/nextcloud_bak && \
    for d in config data custom_apps themes ; do \
        mv /usr/src/nextcloud/$d /usr/src/nextcloud_bak/ ; \
        mkdir /var/www/html/$d ; \
        chown nobody:nogroup /var/www/html/$d ; \
        ln -s /var/www/html/$d /usr/src/nextcloud/ ; \
    done && \
    sed -i 's|/var/www/html|/usr/src/nextcloud|g' /etc/apache2/sites-available/* && \
    sed -i 's|/var/www|/usr/src/nextcloud|g' /etc/apache2/apache2.conf && \
    sed -i 's|/var/www|/usr/src/nextcloud|g' /etc/apache2/conf-available/docker-php.conf

WORKDIR /usr/src/nextcloud
ENV NEXTCLOUD_DATA_DIR /var/www/html/data
VOLUME /var/www/html/config
VOLUME /var/www/html/data
VOLUME /var/www/html/custom_apps
VOLUME /var/www/html/themes

# Change listen port to avoid permission issue when running as a regular user
RUN sed -i 's|^Listen 80$|Listen 8080|g' /etc/apache2/ports.conf && \
    sed -i 's|:80>|:8080>|g' /etc/apache2/sites-enabled/000-default.conf

# Use a /tmp volume so that we can enable readOnlyRootFilesystem
VOLUME /tmp
# Move run and lock files under /tmp
ENV APACHE_PID_FILE /tmp/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /tmp/run/apache2
ENV APACHE_LOCK_DIR /tmp/lock/apache2
# Move PHP conf.d under /tmp
ENV PHP_INI_SCAN_DIR /tmp/php/conf.d

COPY entrypoint-custom.sh /entrypoint-custom.sh

# Install task app
RUN curl -sL https://github.com/${app_tasks_repo}/releases/download/${app_tasks_version}/tasks.tar.gz | tar xz -C /usr/src/nextcloud/apps/ && \
    chown -R nobody:nogroup /usr/src/nextcloud/apps/tasks

USER www-data

ENTRYPOINT ["/entrypoint-custom.sh"]
CMD ["apache2-foreground"]
