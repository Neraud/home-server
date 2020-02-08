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

mkdir -p /tmp/homer/downloaded_assets
if [ -f /opt/images.csv ]; then
    echo "Downloading images"
    while IFS= read -r line; do
        fileName=$(echo $line | cut -d";" -f1)
        filePath=/opt/homer/assets/download/$fileName
        url=$(echo $line | cut -d";" -f2-)
        echo " - $fileName from $url"
        wget -q -O $filePath $url
    done </opt/images.csv
fi

echo "Stating nginx"
nginx -g "daemon off;"
