FROM docker.io/library/python:3.12.4-alpine3.20

RUN apk --no-cache add \
    bash \
    rsync \
    openssh \
    git

RUN mkdir -p /opt

COPY assets /opt
RUN chmod +x /opt/*.sh

RUN pip install --no-cache-dir -r /opt/requirements.txt

ENTRYPOINT [ "/bin/bash" ]
