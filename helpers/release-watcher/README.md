
# Release Watcher

## Description

This is a simple tool to list missed releases using <https://github.com/Neraud/release-watcher>

## Configuration

It uses the watcher list configured in `apps/monitoring/release-watcher/config/watchers.yaml`, so its results should be consistent with the alerts / dashboard generated in the cluster.

## Usage

Simply run the `release-watcher.sh` script and missed releases will be listed in the `data` folder.
