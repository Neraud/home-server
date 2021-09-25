#!/usr/bin/env bash

RESOLVCONF_BACKUP_CONFIGURATION=/etc/resolv.conf.bak

if [ -f "$RESOLVCONF_BACKUP_CONFIGURATION" ]; then
    # Vagrant overwrites the resolv.conf file
    # We use this workaround to detect that we've generated a custom configuration, and restore it
    echo "DNS client backup configuration detected, updating current configuration"
    cp "$RESOLVCONF_BACKUP_CONFIGURATION" /etc/resolv.conf

    # Check NGinx status, with the incorrect DNS it's probably failed
    systemctl status nginx 2>&1 >/dev/null
    nginx_status=$?
    if [ $nginx_status -eq 0 ]; then
        echo "NGinx is started, nothing to do"
    elif [ $nginx_status -eq 4 ]; then
        echo "NGinx isn't installed, nothing to do"
    else
        echo "Restarting NGinx"
        systemctl restart nginx
    fi
fi
