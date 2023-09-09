FROM docker.io/library/python:3.11.5-alpine3.18

RUN pip3 install xmltodict

RUN echo "Create jellyfin user" && \
    addgroup -g 1000 jellyfin && \
    adduser -u 1000 -G jellyfin -s /bin/sh -D jellyfin

ADD --chown=jellyfin:jellyfin inject_conf.py /opt/jellyfin-injection/inject_conf.py
RUN chmod +x /opt/jellyfin-injection/inject_conf.py

USER jellyfin
ENTRYPOINT [ "/opt/jellyfin-injection/inject_conf.py" ]
