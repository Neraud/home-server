#!/bin/bash

TTRSS_CONTEXT_ROOT="${TTRSS_CONTEXT_ROOT:-/}"
TTRSS_RUN_ROOT_DIR="${TTRSS_RUN_ROOT_DIR:-/opt/ttrss}"

mkdir -p /tmp/apache2/conf/

echo "Using TTRSS_CONTEXT_ROOT = $TTRSS_CONTEXT_ROOT"
if [ "$TTRSS_CONTEXT_ROOT" != "/" ]; then
    echo "Alias \"$TTRSS_CONTEXT_ROOT\" \"/var/www/html\"" >/tmp/apache2/conf/20-ttrss-context.conf
else
    rm -f /tmp/apache2/conf/ttrss-context.conf
fi

echo "Ensure TTRSS run directories are available (under $TTRSS_RUN_ROOT_DIR)"
mkdir -p $TTRSS_RUN_ROOT_DIR/lock
mkdir -p $TTRSS_RUN_ROOT_DIR/cache/{images,upload,export}
mkdir -p $TTRSS_RUN_ROOT_DIR/feed-icons
if [ "$TTRSS_RUN_ROOT_DIR" != "/opt/ttrss" ]; then
    cat <<EOF >/tmp/apache2/conf/10-ttrss-feed-icons.conf
Alias "$TTRSS_CONTEXT_ROOT/feed-icons" "$TTRSS_RUN_ROOT_DIR/feed-icons"
<Directory "$TTRSS_RUN_ROOT_DIR/feed-icons">
    Options -Indexes
    Require all granted 
    Allow from all
</Directory>
EOF
else
    rm -f /tmp/apache2/conf/ttrss-feed-icons.conf
fi

echo "Updating schema, if necessary"
docker-php-entrypoint /opt/ttrss/update.php --update-schema=force-yes

if [ "$1" == "job" ]; then
    echo "Stating job"
    docker-php-entrypoint /opt/ttrss/update_daemon2.php
else
    echo "Stating web"
    docker-php-entrypoint apache2-foreground
fi
