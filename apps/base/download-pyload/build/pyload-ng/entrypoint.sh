#!/bin/bash

PYLOAD_PARAMS="--userdir=/config --storagedir=/downloads"
if [ "${PYLOAD_DEBUG}" == "1" ] ; then
    PYLOAD_PARAMS="${PYLOAD_PARAMS} --debug"
fi

echo "Inject configuration"
python3 /opt/configure.py $PYLOAD_PARAMS

echo "Start pyload"
pyload $PYLOAD_PARAMS
