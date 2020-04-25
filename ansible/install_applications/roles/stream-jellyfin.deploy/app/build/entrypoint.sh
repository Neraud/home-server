#!/bin/sh

echo "Starting jellyfin"
dotnet /jellyfin/jellyfin.dll --datadir /config --cachedir /cache
