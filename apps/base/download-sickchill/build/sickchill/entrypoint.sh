#!/bin/sh

if [ -f /app/config_delta.ini ]; then
    echo "Injecting delta configuration"
    /app/sickchill/bin/python3 /app/inject_conf.py /app/config_delta.ini /data/config.ini
    echo ""
fi

echo "Starting Sickchill"
. /app/sickchill/bin/activate
site_packages_dir=$(python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])')
python3 ${site_packages_dir}/SickChill.py --nolaunch --datadir=/data --port 8081
