ARG from_image
FROM $from_image

ARG pyload_version

## Install requirements
RUN apk add --no-cache libcurl ffmpeg nodejs sqlite tesseract-ocr unrar unzip && \
    apk add --no-cache --virtual .build_deps build-base python2-dev curl-dev openssl-dev libffi-dev zlib-dev jpeg-dev && \
    pip install pycurl pycrypto pyOpenSSL pillow && \
    apk del .build_deps

RUN echo "Creating pyload user" && \
    addgroup -g 1000 pyload && \
    adduser -u 1000 -G pyload -s /bin/sh -D pyload

VOLUME [ "/opt/pyload-data" ]
RUN mkdir -p /opt/pyload && \
    chown -R pyload:pyload /opt/pyload && \
    mkdir -p /opt/pyload-data && \
    chown -R pyload:pyload /opt/pyload-data

USER pyload

# Install pyload
RUN mkdir -p /opt/pyload && \
    cd /opt/pyload && \
    wget -qO- https://github.com/pyload/pyload/archive/${pyload_version}.tar.gz | tar xz --strip-components=1


ADD --chown=pyload:pyload entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

EXPOSE 8000

ENTRYPOINT [ "/opt/entrypoint.sh" ]
