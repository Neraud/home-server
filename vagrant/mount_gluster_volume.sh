#!/usr/bin/env bash

gluster_volmume=$1

gluster volume info ${gluster_volmume} >/dev/null 2>/dev/null

if [ $? -ne 0 ]; then
    echo "Volume ${gluster_volmume} doesn't exist !"
    exit 1
fi

echo "Mounting volume ${gluster_volmume}"
mkdir -p /data/volumes/${gluster_volmume}
mount -t glusterfs master-test-1:/${gluster_volmume} /data/volumes/${gluster_volmume}
