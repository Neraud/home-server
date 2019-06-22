FROM linuxserver/heimdall:amd64-2.2.1-ls47

# Execute the install step that's currently inside /etc/cont-init.d/50-config
RUN echo "Installing Heimdall" && \
    mkdir -p /var/www/localhost/heimdall && \
    tar xf \
        /heimdall/heimdall.tar.gz -C \
        /var/www/localhost/heimdall --strip-components=1 && \
    echo -e '\n# Heimdall user authorization\nfastcgi_param  PHP_AUTH_USER $remote_user;\nfastcgi_param  PHP_AUTH_PW $http_authorization;' >> \
    /etc/nginx/fastcgi_params && \
    rm /heimdall/heimdall.tar.gz

# Finish install and force a successful command at the end to avoid breaking the init with our read-only files
RUN echo "Inject read-only workaround" && \
    echo -e "\nchown -R abc:abc /var/www/localhost/heimdall" >> /etc/cont-init.d/50-config && \
    echo -e '\necho "Done"' >> /etc/cont-init.d/50-config

# Required to manually inject data to the SQLite DB
RUN echo "Install PHP SQLite3" && \
    apk add --no-cache --upgrade php-sqlite3
