#!/bin/sh

echo "Creating tmp directories"
mkdir -p /tmp/run
mkdir -p /tmp/nginx/log
mkdir -p /tmp/nginx/lib
mkdir -p $MPLCONFIGDIR

# If the container crashes, the emptyDir mounted on /dev/shm isn't cleaned up
# Frigate can't restart then, and fails with error like :
# FileExistsError: [Errno 17] File exists: '/[camera_name]'
echo "Cleaning /dev/shm"
rm -Rvf /dev/shm/*

echo "Stating Frigate"
/run.sh
