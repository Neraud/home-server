#!/bin/sh

echo "Deploying plugins"
mkdir -p /config/plugins
for plugin_dir in /opt/jellyfin/plugins/* ; do
    plugin_name=$(basename "$plugin_dir")
    echo " - $plugin_name"
    if [ -d "/config/plugins/$plugin_name" ] ; then
        echo "removing old version"
        rm -Rf "/config/plugins/$plugin_name"
    fi
    cp -R "/opt/jellyfin/plugins/$plugin_name" "/config/plugins/$plugin_name"
done

echo "Starting jellyfin"
/jellyfin/jellyfin --datadir /config --cachedir /cache
