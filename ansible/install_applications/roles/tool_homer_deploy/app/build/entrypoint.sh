#!/bin/sh

# Copy the default assets
# The default entrypoint only copies them if the assets folder is empty
cp -Ri /www/default-assets/* /www/assets/

mkdir -p /www/assets/download
if [ -f /opt/images.csv ]; then
    echo "Downloading images"
    while IFS= read -r line; do
        fileName=$(echo $line | cut -d";" -f1)
        filePath=/www/assets/download/$fileName
        url=$(echo $line | cut -d";" -f2-)
        echo " - $fileName from $url"
        wget -q -O $filePath $url
    done </opt/images.csv
else
    echo "No image to download"
fi

echo "Linking dashboard-icons"
ln -s /opt/dashboard-icons /www/assets/dashboard-icons

echo "Starting standard entrypoint"
/bin/sh /entrypoint.sh
