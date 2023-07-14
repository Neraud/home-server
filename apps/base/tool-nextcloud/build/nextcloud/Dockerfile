FROM docker.io/library/nextcloud:25.0.5-apache

ARG supercronic_repo=aptible/supercronic
ARG supercronic_version=v0.2.1
ARG supercronic_sha1sum=d7f4c0886eb85249ad05ed592902fa6865bb9d70
ARG app_calendar_repo=nextcloud-releases/calendar
ARG app_calendar_version=v4.3.1
ARG app_contacts_repo=nextcloud-releases/contacts
ARG app_contacts_version=v5.2.0
ARG app_notes_repo=nextcloud/notes
ARG app_notes_version=v4.7.2
ARG app_tasks_repo=nextcloud/tasks
ARG app_tasks_version=v0.14.5
ARG app_twofactor_totp_repo=nextcloud-releases/twofactor_totp
ARG app_twofactor_totp_version=v6.4.1

# See https://github.com/nextcloud/docker/blob/master/.examples/dockerfiles/cron/apache/Dockerfile
# Install supervisor
RUN apt-get update && apt-get install -y \
    supervisor \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /var/log/supervisord /var/run/supervisord
COPY supervisord.conf /

# Install supercronic, as crond doesn't like being run as non-root
RUN curl -fsSLO "https://github.com/${supercronic_repo}/releases/download/${supercronic_version}/supercronic-linux-amd64" \
 && echo "${supercronic_sha1sum} supercronic-linux-amd64" | sha1sum -c - \
 && chmod +x "supercronic-linux-amd64" \
 && mv "supercronic-linux-amd64" "/usr/local/bin/supercronic-linux-amd64" \
 && ln -s "/usr/local/bin/supercronic-linux-amd64" /usr/local/bin/supercronic

COPY cron-custom.sh /cron-custom.sh

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
    sed -i 's|/var/www|/usr/src/nextcloud|g' /etc/apache2/conf-available/docker-php.conf && \
    sed -i 's|/var/www/html|/usr/src/nextcloud|g' /var/spool/cron/crontabs/www-data

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

# Install Calendar app
RUN curl -sL https://github.com/${app_calendar_repo}/releases/download/${app_calendar_version}/calendar-${app_calendar_version}.tar.gz  | tar xz -C /usr/src/nextcloud/apps/ && \
    chown -R nobody:nogroup /usr/src/nextcloud/apps/calendar
# Install Contacts app
RUN curl -sL https://github.com/${app_contacts_repo}/releases/download/${app_contacts_version}/contacts-${app_contacts_version}.tar.gz  | tar xz -C /usr/src/nextcloud/apps/ && \
    chown -R nobody:nogroup /usr/src/nextcloud/apps/contacts
# Install Notes app
RUN curl -sL https://github.com/${app_notes_repo}/releases/download/${app_notes_version}/notes.tar.gz | tar xz -C /usr/src/nextcloud/apps/ && \
    chown -R nobody:nogroup /usr/src/nextcloud/apps/notes
# Install Tasks app
RUN curl -sL https://github.com/${app_tasks_repo}/releases/download/${app_tasks_version}/tasks.tar.gz | tar xz -C /usr/src/nextcloud/apps/ && \
    chown -R nobody:nogroup /usr/src/nextcloud/apps/tasks
# Install Two Factor Totp app
RUN curl -sL https://github.com/${app_twofactor_totp_repo}/releases/download/${app_twofactor_totp_version}/twofactor_totp-${app_twofactor_totp_version}.tar.gz  | tar xz -C /usr/src/nextcloud/apps/ && \
    chown -R nobody:nogroup /usr/src/nextcloud/apps/twofactor_totp

USER www-data

# We use a custom command, so make sure nextcloud install is triggered
ENV NEXTCLOUD_UPDATE 1

ENTRYPOINT ["/entrypoint-custom.sh"]
CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
