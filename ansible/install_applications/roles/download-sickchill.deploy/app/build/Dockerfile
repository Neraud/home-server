ARG from_image
FROM $from_image

ARG sickchill_version

# Install requirements
RUN apk add --update --no-cache git mediainfo nodejs unrar tzdata libffi openssl && \
    apk add --no-cache --virtual .build-deps gcc libffi-dev openssl-dev musl-dev && \
    pip install pyopenssl && \
    apk del .build-deps

RUN echo "Creating sickchill user" && \
    addgroup -g 1000 sickchill && \
    adduser -u 1000 -G sickchill -s /bin/sh -D sickchill

VOLUME [ "/opt/sickchill-data" ]
RUN mkdir -p /opt/sickchill && \
    chown -R sickchill:sickchill /opt/sickchill && \
    mkdir -p /opt/sickchill-data && \
    chown -R sickchill:sickchill /opt/sickchill-data

USER sickchill

# Install sickchill
RUN mkdir -p /opt/sickchill && \
    cd /opt/sickchill && \
    wget -qO- https://github.com/SickChill/SickChill/archive/${sickchill_version}.tar.gz | tar xz --strip-components=1

# Make sure cache is linked to the data dir : See https://github.com/SickChill/SickChill/issues/6010
RUN ln -s /opt/sickchill-data/cache /opt/sickchill/gui/slick/cache

ADD --chown=sickchill:sickchill entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

EXPOSE 8081

ENTRYPOINT [ "/opt/entrypoint.sh" ]
