#!/bin/sh

echo "Injecting core config"
python /opt/deluge/inject_core_config.py

echo "Starting deluged"
deluged --do-not-daemonize --config /opt/deluge/config --loglevel=${DELUGE_LOGLEVEL}
