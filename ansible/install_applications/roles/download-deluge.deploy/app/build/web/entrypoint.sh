#!/bin/sh

echo "Injecting web config"
python /opt/deluge/inject_web_config.py

echo "Starting deluge-web"
deluge-web --do-not-daemonize --config /home/deluge/.config/deluge --loglevel=${DELUGE_LOGLEVEL}
