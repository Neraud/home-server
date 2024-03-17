#!/bin/sh

if [ -f /config/images.csv ]; then
    echo "Downloading images"
    while IFS= read -r line; do
        fileName=$(echo $line | cut -d";" -f1)
        filePath=/var/www/olivetin/customIcons/$fileName
        url=$(echo $line | cut -d";" -f2-)
        echo " - $fileName from $url"
        curl -s -o $filePath $url
    done </config/images.csv
fi

echo "Starting OliveTin"
/usr/bin/OliveTin
