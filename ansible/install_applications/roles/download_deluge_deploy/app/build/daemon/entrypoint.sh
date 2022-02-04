#!/bin/sh

echo "Injecting core config"
python3 /opt/deluge/inject_core_config.py

echo "Injecting autoadd config"
python3 /opt/deluge/inject_autoadd_config.py

echo "Starting deluged"
deluged --do-not-daemonize --config /home/deluge/.config/deluge --loglevel=${DELUGE_LOGLEVEL}
