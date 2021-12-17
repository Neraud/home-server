#!/usr/bin/env bash

echo "Building debian-backports-base:bullseye image"
podman build -t debian-backports-base:bullseye base/

echo "Building ser2net-backports image"
podman build -t ser2net-backports ser2net/

mkdir -p ser2net/out

echo "Building ser2net-backports"
podman run --rm -it -v $(pwd)/ser2net/out:/out ser2net-backports
