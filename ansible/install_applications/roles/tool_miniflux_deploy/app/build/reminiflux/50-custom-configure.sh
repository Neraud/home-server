#!/bin/sh

set -e

echo "Wipe and prepare tmp folders"
rm -Rf /tmp/nginx
mkdir -p /tmp/cache/nginx
mkdir -p /tmp/run
mkdir -p /tmp/nginx/conf.d

echo "Init default nginx configuration"
mkdir -p /tmp/nginx/conf.d
cp /etc/nginx/conf.d/* /tmp/nginx/conf.d/

if [ ! -z "${NGINX_PORT}" ] ; then
    echo "Configuring nginx port to ${NGINX_PORT}"
    sed -i -E "s/(listen +(.*:)?)80;/\1${NGINX_PORT};/g" /tmp/nginx/conf.d/default.conf
else
    echo "NGINX_PORT not set, keeping the default listen port"
fi

echo "Move root under tmp"
sed -i -E "s|/usr/share/nginx/html|/tmp/nginx/html|g" /tmp/nginx/conf.d/default.conf

if [ -z "${CONTEXT_ROOT}" -o "${CONTEXT_ROOT}" == "/" ] ; then
    echo "Configuring nginx context root to /"
    mkdir -p /tmp/nginx
    rm -Rf /tmp/nginx/html
    ln -s /usr/share/nginx/html /tmp/nginx/
else
    echo "Configuring nginx context root to ${CONTEXT_ROOT}"
    mkdir -p /tmp/nginx/html
    ln -s /usr/share/nginx/html /tmp/nginx/html/${CONTEXT_ROOT}
fi
