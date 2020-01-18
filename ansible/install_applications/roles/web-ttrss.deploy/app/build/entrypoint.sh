#!/bin/bash

TTRSS_CONTEXT_ROOT="${TTRSS_CONTEXT_ROOT:-/}"

echo "Using TTRSS_CONTEXT_ROOT = $TTRSS_CONTEXT_ROOT"
if [ "$TTRSS_CONTEXT_ROOT" != "/" ]; then
    mkdir -p /tmp/apache2/conf/
    echo "Alias \"$TTRSS_CONTEXT_ROOT\" \"/var/www/html\"" >/tmp/apache2/conf/ttrss-context.conf
fi

echo "Ensure TTRSS run directories are available (under $TTRSS_RUN_ROOT_DIR)"
mkdir -p $TTRSS_RUN_ROOT_DIR/lock
mkdir -p $TTRSS_RUN_ROOT_DIR/cache/{images,upload,export}
mkdir -p $TTRSS_RUN_ROOT_DIR/feed-icons

if [ "$1" == "job" ]; then
    echo "Stating job"
    docker-php-entrypoint /opt/ttrss/update_daemon2.php
else
    echo "Stating web"
    docker-php-entrypoint apache2-foreground
fi
