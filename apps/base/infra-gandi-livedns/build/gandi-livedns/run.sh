#!/usr/bin/env bash

if [[ -z "${APIKEY}" || -z "${RECORD_LIST}" || -z "${DOMAIN}" ]]; then
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [ERROR] Mandatory variable APIKEY, DOMAIN or RECORD_LIST not defined."
    exit 1
fi

if [[ -z "${REFRESH_INTERVAL}" || ${REFRESH_INTERVAL} -eq 0 ]]; then
    if [ "${SET_IPV4}" = 'yes' ]; then
        ./update_ipv4.sh
    fi
else
    echo "$(date "+[%Y-%m-%d %H:%M:%S]") [INFO] Starting loop with REFRESH_INTERVAL = ${REFRESH_INTERVAL}"
    while true; do
        if [ "${SET_IPV4}" = 'yes' ]; then
            ./update_ipv4.sh
        fi
        sleep ${REFRESH_INTERVAL}
    done
fi
