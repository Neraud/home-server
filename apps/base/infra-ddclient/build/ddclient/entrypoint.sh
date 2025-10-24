#!/usr/bin/env bash

set -euo pipefail

DDCLIENT_CONFIG_PATH=${DDCLIENT_CONFIG_PATH:-/tmp/ddclient.conf}

echo "Generating DDClient configuration at ${DDCLIENT_CONFIG_PATH}"
cat << EOF > ${DDCLIENT_CONFIG_PATH}
# General config
daemon=${DDCLIENT_CONF_DAEMON:-1800}
foreground=yes
verbose=${DDCLIENT_CONF_VERBOSE:-yes}
debug=${DDCLIENT_CONF_DEBUG:-no}
ssl=${DDCLIENT_CONF_SSL:-yes}
cache=${DDCLIENT_CONF_CACHE:-/tmp/ddclient.cache}

# Router
usev4=webv4
webv4=${DDCLIENT_CONF_WEB:-ipify-ipv4}

# Protocol
protocol=${DDCLIENT_CONF_PROTOCOL:-'dyndns2'}
server=${DDCLIENT_CONF_SERVER:?'DDCLIENT_CONF_SERVER is required'}
login=${DDCLIENT_CONF_LOGIN:?'DDCLIENT_CONF_LOGIN is required'}
password=${DDCLIENT_CONF_PASSWORD:?'DDCLIENT_CONF_PASSWORD is required'}
${DDCLIENT_CONF_HOST:?'DDCLIENT_CONF_HOST is required'}
EOF

chmod 400 ${DDCLIENT_CONFIG_PATH}

echo "Starting ddclient"
ddclient -file ${DDCLIENT_CONFIG_PATH}
