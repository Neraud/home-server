#!/bin/bash
kill -s SIGUSR2 1
while [ -e /proc/1 ]; do sleep 1; done
