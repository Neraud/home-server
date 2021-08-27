#!/bin/sh

echo "Copying platformio to tmp"
cp -R $HOME/.platformio /tmp/

echo "Starting esphome $*"
esphome $*
