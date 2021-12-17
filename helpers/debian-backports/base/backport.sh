#!/usr/bin/env bash

PACKAGE_NAME=$1
PACKAGE_DESC_URL=$2

cd ${WORK_DIR}

echo "Backporting package ${PACKAGE_NAME}"

echo " - downloading sources from desc ${PACKAGE_DESC_URL}"
dget -x ${PACKAGE_DESC_URL}

cd ${WORK_DIR}/${PACKAGE_NAME}/

echo " - installing dependencies"
mk-build-deps --install --remove --tool "apt-get -y -o Debug::pkgProblemResolver=yes --no-install-recommends"

echo " - updating changelog"
dch --bpo 'Backported for bullseye'

echo " - building"
dpkg-buildpackage -b -us -uc

cd ${WORK_DIR}
