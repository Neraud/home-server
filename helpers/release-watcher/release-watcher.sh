#!/usr/bin/env bash

if [ -d out ]; then
    rm -R out
fi
mkdir out

podman run \
    -v ./config.yaml:/data/config.yaml \
    -v ../../apps/base/monitoring-release-watcher/deploy/config/watchers:/data/watchers \
    -v ./out:/data/out \
    ghcr.io/neraud/release-watcher:latest
