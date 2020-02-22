ARG from_image
FROM $from_image

ENV DELUGE_LOGLEVEL=info

# Download a legacy maxmind geoip database and configure deluge to use it
ENV DELUGE_CONF_CORE_GEOIP_DB_LOCATION /opt/deluge/GeoIP-country.dat
# See : https://www.miyuru.lk/geoiplegacy
RUN wget -O - https://dl.miyuru.lk/geoip/maxmind/country/maxmind4.dat.gz | gunzip -c > /opt/deluge/GeoIP-country.dat

ADD --chown=deluge:deluge inject_core_config.py /opt/deluge/inject_core_config.py
ADD --chown=deluge:deluge entrypoint.sh /opt/deluge/entrypoint.sh
RUN chmod +x /opt/deluge/entrypoint.sh

EXPOSE 58846 58946 58946/udp

ENTRYPOINT [ "/opt/deluge/entrypoint.sh" ]
