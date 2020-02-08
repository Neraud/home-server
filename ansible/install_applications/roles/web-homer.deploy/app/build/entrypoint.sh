#!/bin/sh

HOMER_CONTEXT_ROOT="${HOMER_CONTEXT_ROOT:-/}"

mkdir -p /tmp/nginx/conf/

echo "Using HOMER_CONTEXT_ROOT = $HOMER_CONTEXT_ROOT"
if [ "$HOMER_CONTEXT_ROOT" != "/" ]; then
    cat <<EOF >/tmp/nginx/conf/20-homer-context.conf
location $HOMER_CONTEXT_ROOT {
    alias /usr/share/nginx/html;
}
EOF
else
    rm -f /tmp/nginx/conf/20-homer-context.conf
fi

echo "Stating nginx"
nginx -g "daemon off;"
