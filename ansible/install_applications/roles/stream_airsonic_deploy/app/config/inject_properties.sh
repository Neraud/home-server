#!/usr/bin/env bash

SOURCE=/config/airsonic.properties.delta
TARGET=/airsonic/data/airsonic.properties
PROPERTIES_TO_DEPLOY="^(Ldap|Smtp)"

if [ ! -f "${TARGET}" ]; then
    echo "airsonic.properties doesn't exist yet, deploying the delta as is"
    cp ${SOURCE} ${TARGET}
else
    echo "airsonic.properties exists, merging the delta"
    mv ${TARGET} ${TARGET}.orig
    grep -Ev "${PROPERTIES_TO_DEPLOY}" ${TARGET}.orig >${TARGET}
    grep -E "${PROPERTIES_TO_DEPLOY}" ${SOURCE} >>${TARGET}
fi

chmod 775 ${TARGET}
echo "Finished"
