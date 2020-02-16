#!/bin/sh

echo "Injecting core config"
python /opt/deluge/inject_core_config.py

echo "Starting deluged"
deluged --do-not-daemonize --config /home/deluge/.config/deluge --loglevel=${DELUGE_LOGLEVEL}
