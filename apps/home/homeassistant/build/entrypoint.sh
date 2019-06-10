#!/usr/bin/env bash

echo "Searching for socat configurations at /config/socat.cfg"
if [ -f /config/socat.cfg ] ; then
    echo "Generating and starting socat services"
    cat /config/socat.cfg | sed 's/#.*//g' | grep -Ev "^$" | while read line ; do

        SOCAT_NAME=$(echo $line | cut -d"=" -f1)
        SOCAT_PARAMETERS=$(echo $line | cut -d"=" -f2-)

        echo " - $SOCAT_NAME"

        cat <<EOF > /etc/init.d/socat-${SOCAT_NAME}
#!/bin/bash
case "\$1" in
    start)
        socat $SOCAT_PARAMETERS &
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart}"
esac
exit 0
EOF
        chmod +x /etc/init.d/socat-${SOCAT_NAME}
        service socat-${SOCAT_NAME} start
    done
else
    echo "Not found, skipping"
fi

echo "Starting Home Assistant"
python -m homeassistant --config /config
