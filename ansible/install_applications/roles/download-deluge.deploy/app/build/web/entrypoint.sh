#!/bin/sh

echo "Injecting web config"
python /opt/deluge/inject_web_config.py

echo "Starting deluge-web"
deluge-web --do-not-daemonize --config /opt/deluge/config --loglevel=${DELUGE_LOGLEVEL}
