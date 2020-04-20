ARG from_image
FROM $from_image

ARG deluge_version
ENV DELUGE_LOGLEVEL=info

RUN echo "Install build requirements" && \
    apk add --no-cache --virtual .build_deps build-base python2-dev libffi-dev openssl-dev zlib-dev jpeg-dev geoip-dev && \
    echo "Install requirements" && \
    apk add --no-cache geoip && \
    pip install GeoIP && \
    echo "Install deluge" && \
    pip install deluge==${deluge_version} && \
    echo "Clear build deps" && \
    apk del .build_deps

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
