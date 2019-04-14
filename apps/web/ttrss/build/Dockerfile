
# Keep the image version in sync with the ttrss_schema_url variable
FROM linuxserver/tt-rss:amd64-19.2-ls6

RUN \
    echo "**** install plugin LDAP Auth ****" && \
    curl -o /tmp/TTRSS-Auth-LDAP.tar.gz -L "https://github.com/hydrian/TTRSS-Auth-LDAP/archive/52e452cc97b5101dc6d9e911462fe5e161197930.tar.gz" && \
    tar xf /tmp/TTRSS-Auth-LDAP.tar.gz  -C /var/www/html/plugins.local --strip-components=2 && \
    echo "**** install plugin Mailer SMTP ****" && \
    curl -o /tmp/ttrss-mailer-smtp.tar.gz -L "https://git.tt-rss.org/fox/ttrss-mailer-smtp/archive/8906bf9fead9c1ef52e2e502b78480d8fd92e112.tar.gz" && \
    mkdir /var/www/html/plugins.local/mailer_smtp && \
    tar xf /tmp/ttrss-mailer-smtp.tar.gz  -C /var/www/html/plugins.local/mailer_smtp --strip-components=1 && \
    echo "**** cleanup ****" && \
    rm -rf /tmp/*

# TODO : workaround while waiting for the MR to be accepted
ADD mailer_smtp/init.php /var/www/html/plugins.local/mailer_smtp/init.php
