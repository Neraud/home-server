#!/bin/sh

echo "Create folders for nzbtomedia"
mkdir -p /opt/sabnzbd-data/nzbtomedia/logs

echo "Inject configuration"
python3 /opt/inject_conf.py

echo "Start SABnzbd"
python3 -OO /opt/sabnzbd/SABnzbd.py --config-file /opt/sabnzbd-data --server 0.0.0.0:8080
