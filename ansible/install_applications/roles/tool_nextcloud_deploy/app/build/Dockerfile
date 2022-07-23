#ARG from_image
#FROM $from_image

FROM nextcloud:24.0.2-apache

# Link nextcloud sources to /var/www/html_new and change docroot
RUN ln -s /usr/src/nextcloud /var/www/html_new && \
    sed -i 's|/var/www/html|/var/www/html_new|g' /etc/apache2/sites-available/*

# Change listen port to avoid permission issue when running as a regular user
RUN sed -i 's|^Listen 80$|Listen 8080|g' /etc/apache2/ports.conf && \
    sed -i 's|:80>|:8080>|g' /etc/apache2/sites-enabled/000-default.conf

COPY entrypoint-custom.sh /entrypoint-custom.sh

# TODO non root user
#USER www-data

ENTRYPOINT ["/entrypoint-custom.sh"]
CMD ["apache2-foreground"]
