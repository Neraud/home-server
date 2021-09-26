#!/bin/sh

echo "Creating tmp directories"
mkdir -p /tmp/run
mkdir -p /tmp/nginx/log
mkdir -p /tmp/nginx/lib
mkdir -p $MPLCONFIGDIR

echo "Stating Frigate"
/run.sh
