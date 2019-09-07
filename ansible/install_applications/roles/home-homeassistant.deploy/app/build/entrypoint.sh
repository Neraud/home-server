#!/usr/bin/env bash

echo "Starting supervisord"
supervisord --configuration /etc/supervisor/supervisord.conf

echo "Starting Home Assistant"
python -m homeassistant --config /config
