FROM docker.io/emmercm/libtorrent:2.0.11-alpine as builder

RUN python3 -m venv /opt/venv

# Make sure we use the virtualenv
ENV PATH="/opt/venv/bin:$PATH"

RUN echo "Install build requirements" && \
    apk add --no-cache build-base python3-dev py3-pip && \
    pip3 install libtorrent==2.0.11 && \
    echo "Install deluge" && \
    pip3 install deluge==2.2.0 && \
    apk add --no-cache geoip-dev && \
    pip3 install GeoIP

FROM docker.io/emmercm/libtorrent:2.0.11-alpine

COPY --from=builder /opt/venv /opt/venv

# Make sure we use the virtualenv
ENV PATH="/opt/venv/bin:$PATH"

RUN echo "Creating deluge user" && \
    addgroup -g 1000 deluge && \
    adduser -u 1000 -G deluge -s /bin/sh -D deluge

ENV XDG_CONFIG_HOME=/home/deluge/.config

VOLUME [ "/home/deluge/.config/deluge" ]
RUN mkdir -p /home/deluge/.config/deluge && \
    chown -R deluge:deluge /home/deluge && \
    mkdir -p /opt/deluge && \
    chown -R deluge:deluge /opt/deluge

ENV PYTHON_EGG_CACHE=/tmp/deluge/.cache/Python-Eggs
RUN mkdir -p /tmp/deluge/.cache/Python-Eggs && \
    chown -R deluge:deluge /tmp/deluge

USER deluge

ENV DELUGE_LOGLEVEL=info

# Download a legacy maxmind geoip database and configure deluge to use it
ENV DELUGE_CONF_CORE_GEOIP_DB_LOCATION /opt/deluge/GeoIP-country.dat
# See : https://www.miyuru.lk/geoiplegacy
RUN wget -O - https://dl.miyuru.lk/geoip/maxmind/country/maxmind4.dat.gz | gunzip -c > /opt/deluge/GeoIP-country.dat

ADD --chown=deluge:deluge inject_core_config.py /opt/deluge/inject_core_config.py
ADD --chown=deluge:deluge inject_autoadd_config.py /opt/deluge/inject_autoadd_config.py
ADD --chown=deluge:deluge entrypoint.sh /opt/deluge/entrypoint.sh
RUN chmod +x /opt/deluge/entrypoint.sh

EXPOSE 58846 58946 58946/udp

ENTRYPOINT [ "/opt/deluge/entrypoint.sh" ]
