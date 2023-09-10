
# Release Watcher

## Description

This is a simple tool to list missed releases using <https://github.com/Neraud/release-watcher>

## Configuration

It uses the watcher list configured in `apps/base/monitoring-release-watcher/deploy/config/watchers`, so its results should be consistent with the alerts / dashboard generated in the cluster.

## Usage

Simply run the `release-watcher.sh` script and missed releases will be listed in the `out` folder.
