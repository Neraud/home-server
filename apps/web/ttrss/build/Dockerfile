
# Keep the image version in sync with the ttrss_schema_url variable
FROM linuxserver/tt-rss:amd64-19.2-ls6

RUN \
    echo "**** install plugin LDAP Auth ****" && \
    curl -o /tmp/TTRSS-Auth-LDAP.tar.gz -L "https://github.com/hydrian/TTRSS-Auth-LDAP/archive/52e452cc97b5101dc6d9e911462fe5e161197930.tar.gz" && \
    tar xf /tmp/TTRSS-Auth-LDAP.tar.gz  -C /var/www/html/plugins.local --strip-components=2 && \
    echo "**** cleanup ****" && \
    rm -rf /tmp/*
