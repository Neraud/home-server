#!/bin/sh

echo "Inject configuration"
python /opt/inject_conf.py

echo "Start SABnzbd"
python -OO /opt/sabnzbd/SABnzbd.py --config-file /opt/sabnzbd-data --server 0.0.0.0:8080

