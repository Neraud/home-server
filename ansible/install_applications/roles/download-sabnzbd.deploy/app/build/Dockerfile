ARG from_image

FROM $from_image as par2_builder
ARG par2cmdline_version

# Install requirements
RUN apk add --no-cache build-base automake autoconf

RUN mkdir -p /opt/par2cmdline && \
    cd /opt/par2cmdline && \
    wget -qO- https://github.com/Parchive/par2cmdline/archive/${par2cmdline_version}.tar.gz | tar xz --strip-components=1

RUN cd /opt/par2cmdline && \
    ./automake.sh && \
    ./configure && \
    make && \
    make check && \
    make install




FROM $from_image
ARG sabnzbd_version
ARG nzbToMedia_version

# Install requirements
RUN apk add --no-cache openssl unrar unzip p7zip ffmpeg libgomp && \
    apk add --no-cache --virtual .build_deps build-base python2-dev libffi-dev openssl-dev && \
    pip install cheetah3 cryptography sabyenc && \
    apk del .build_deps

# Fetch par2 from builder
COPY --from=par2_builder /usr/local/bin/par2 /usr/local/bin/par2
RUN ln -sf /usr/local/bin/par2 /usr/local/bin/par2create && \
    ln -sf /usr/local/bin/par2 /usr/local/bin/par2verify && \
    ln -sf /usr/local/bin/par2 /usr/local/bin/par2repair

RUN echo "Creating sabnzbd user" && \
    addgroup -g 1000 sabnzbd && \
    adduser -u 1000 -G sabnzbd -s /bin/sh -D sabnzbd

VOLUME [ "/opt/sabnzbd-data" ]
RUN mkdir -p /opt/sabnzbd && \
    chown -R sabnzbd:sabnzbd /opt/sabnzbd && \
    mkdir -p /opt/sabnzbd-data && \
    chown -R sabnzbd:sabnzbd /opt/sabnzbd-data && \
    mkdir -p /opt/nzbToMedia && \
    chown -R sabnzbd:sabnzbd /opt/nzbToMedia

USER sabnzbd

# Install sabnzbd
RUN cd /opt/sabnzbd && \
    wget -qO- https://github.com/sabnzbd/sabnzbd/archive/${sabnzbd_version}.tar.gz | tar xz --strip-components=1

RUN cd /opt/sabnzbd && \
    python tools/make_mo.py

# Install nzbToMedia
RUN cd /opt/nzbToMedia && \
    wget -qO- https://github.com/clinton-hall/nzbToMedia/archive/${nzbToMedia_version}.tar.gz | tar xz --strip-components=1 && \
    ln -s /opt/sabnzbd-data/autoProcessMedia.cfg /opt/nzbToMedia/autoProcessMedia.cfg

ADD --chown=sabnzbd:sabnzbd entrypoint.sh /opt/entrypoint.sh
ADD --chown=sabnzbd:sabnzbd inject_conf.py /opt/inject_conf.py
RUN chmod +x /opt/entrypoint.sh

EXPOSE 8000

ENTRYPOINT [ "/opt/entrypoint.sh" ]
