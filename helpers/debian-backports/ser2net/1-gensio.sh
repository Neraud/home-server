#!/usr/bin/env bash

# From https://packages.debian.org/bookworm/gensio-bin
PACKAGE_NAME=gensio-2.3.5
PACKAGE_DESC_URL=https://snapshot.debian.org/archive/debian/20211122T151224Z/pool/main/g/gensio/gensio_2.3.5-1.dsc

/opt/backports/backport.sh "${PACKAGE_NAME}" "${PACKAGE_DESC_URL}"

# Install built packages to be able to build ser2net next
apt-get -y install ${WORK_DIR}/libgensio-dev_2.3.5-1~bpo*_amd64.deb ${WORK_DIR}/libgensio0_2.3.5-1~bpo*_amd64.deb ${WORK_DIR}/python3-gensio_2.3.5-1~bpo*_amd64.deb

cp ${WORK_DIR}/libgensio0_2.3.5-1~bpo*_amd64.deb ${OUT_DIR}/
