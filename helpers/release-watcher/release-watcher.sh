#!/usr/bin/env bash

if [ ! -d release-watcher ]; then
    git clone https://github.com/Neraud/release-watcher
fi

if [ -d data ]; then
    rm -R data
fi
mkdir data

cd release-watcher
git pull
docker build -t release-watcher-helper .

cd ..
cp ../../apps/monitoring/release-watcher/config/watchers.yaml ./data/
docker run -v $(pwd):/data release-watcher-helper
