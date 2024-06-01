FROM docker.io/library/python:3.12.3-alpine3.20

RUN pip3 install lxml

RUN echo "Create syncthing user" && \
    addgroup -g 1000 syncthing && \
    adduser -u 1000 -G syncthing -s /bin/sh -D syncthing

ADD --chown=syncthing:syncthing inject_conf.py /opt/syncthing-injection/inject_conf.py
RUN chmod +x /opt/syncthing-injection/inject_conf.py

USER syncthing
ENTRYPOINT [ "/opt/syncthing-injection/inject_conf.py" ]
