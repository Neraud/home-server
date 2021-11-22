#!/bin/sh

if [ -f /app/config_delta.ini ]; then
    echo "Injecting delta configuration"
    /app/sickchill/bin/python3 /app/inject_conf.py /app/config_delta.ini /data/config.ini
    echo ""
fi

echo "Starting Sickchill"
/app/sickchill/bin/python3 /app/sickchill/lib/python3.10/site-packages/SickChill.py --nolaunch --datadir=/data --port 8081
