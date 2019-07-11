ARG from_image
FROM $from_image

RUN \
    echo "**** install plugin LDAP Auth ****" && \
    curl -o /tmp/TTRSS-Auth-LDAP.tar.gz -L "https://github.com/hydrian/TTRSS-Auth-LDAP/archive/52e452cc97b5101dc6d9e911462fe5e161197930.tar.gz" && \
    tar xf /tmp/TTRSS-Auth-LDAP.tar.gz  -C /var/www/html/plugins.local --strip-components=2 && \
    echo "**** install plugin Mailer SMTP ****" && \
    curl -o /tmp/ttrss-mailer-smtp.tar.gz -L "https://git.tt-rss.org/fox/ttrss-mailer-smtp/archive/eebc18f00ef5fbaebd4f9a6e43685f87ba8b537f.tar.gz" && \
    mkdir /var/www/html/plugins.local/mailer_smtp && \
    tar xf /tmp/ttrss-mailer-smtp.tar.gz  -C /var/www/html/plugins.local/mailer_smtp --strip-components=1 && \
    echo "**** cleanup ****" && \
    rm -rf /tmp/*
