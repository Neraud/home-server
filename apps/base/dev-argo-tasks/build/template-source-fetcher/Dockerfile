FROM docker.io/library/python:3.13.2-alpine3.21

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
