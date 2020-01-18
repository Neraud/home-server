#!/bin/bash

TTRSS_CONTEXT_ROOT="${TTRSS_CONTEXT_ROOT:-/}"

echo "Using TTRSS_CONTEXT_ROOT=$TTRSS_CONTEXT_ROOT"
if [ "$TTRSS_CONTEXT_ROOT" != "/" ]; then
    rm /var/www/html
    mkdir /var/www/html
    ln -s /opt/ttrss /var/www/html/$TTRSS_CONTEXT_ROOT
fi

docker-php-entrypoint apache2-foreground
