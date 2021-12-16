#!/usr/bin/env bash

# From https://packages.debian.org/bookworm/ser2net
PACKAGE_NAME=ser2net-4.3.4
PACKAGE_DESC_URL=http://deb.debian.org/debian/pool/main/s/ser2net/ser2net_4.3.4-2.dsc

/opt/backports/backport.sh "${PACKAGE_NAME}" "${PACKAGE_DESC_URL}"

cp ${WORK_DIR}/ser2net_4.3.4-2~bpo*_amd64.deb ${OUT_DIR}/
