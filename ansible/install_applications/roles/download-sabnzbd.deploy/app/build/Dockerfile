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
RUN apk add --no-cache openssl unrar unzip p7zip ffmpeg libgomp

# Fetch par2 from builder
COPY --from=par2_builder /usr/local/bin/par2 /usr/local/bin/par2
RUN ln -sf /usr/local/bin/par2 /usr/local/bin/par2create && \
    ln -sf /usr/local/bin/par2 /usr/local/bin/par2verify && \
    ln -sf /usr/local/bin/par2 /usr/local/bin/par2repair

RUN echo "Creating sabnzbd user" && \
    addgroup -g 1000 sabnzbd && \
    adduser -u 1000 -G sabnzbd -s /bin/sh -D sabnzbd

# Install sabnzbd
RUN mkdir -p /opt/sabnzbd && \
    cd /opt/sabnzbd && \
    wget -qO- https://github.com/sabnzbd/sabnzbd/archive/${sabnzbd_version}.tar.gz | tar xz --strip-components=1


# TODO temp workaround waiting for version 3.1.x
# See https://github.com/sabnzbd/sabnzbd/issues/1609
RUN sed -i 's/^feedparser$/feedparser<6.0.0/' /opt/sabnzbd/requirements.txt

# Install python requirements
RUN apk add --no-cache --virtual .build_deps build-base python2-dev libffi-dev openssl-dev && \
    pip install -r /opt/sabnzbd/requirements.txt && \
    apk del .build_deps

VOLUME [ "/opt/sabnzbd-data" ]
RUN mkdir -p /opt/sabnzbd && \
    chown -R sabnzbd:sabnzbd /opt/sabnzbd && \
    mkdir -p /opt/sabnzbd-data && \
    chown -R sabnzbd:sabnzbd /opt/sabnzbd-data && \
    mkdir -p /opt/nzbToMedia && \
    chown -R sabnzbd:sabnzbd /opt/nzbToMedia

USER sabnzbd

RUN cd /opt/sabnzbd && \
    python tools/make_mo.py

# Install nzbToMedia
RUN cd /opt/nzbToMedia && \
    wget -qO- https://github.com/clinton-hall/nzbToMedia/archive/${nzbToMedia_version}.tar.gz | tar xz --strip-components=1 && \
    ln -s /opt/sabnzbd-data/nzbtomedia/autoProcessMedia.cfg /opt/nzbToMedia/autoProcessMedia.cfg && \
    ln -s /opt/sabnzbd-data/nzbtomedia/autoProcessMedia.cfg.old /opt/nzbToMedia/autoProcessMedia.cfg.old && \
    ln -s /opt/sabnzbd-data/nzbtomedia/nzbtomedia.db /opt/nzbToMedia/nzbtomedia.db && \
    ln -s /opt/sabnzbd-data/nzbtomedia/logs /opt/nzbToMedia/logs

ADD --chown=sabnzbd:sabnzbd entrypoint.sh /opt/entrypoint.sh
ADD --chown=sabnzbd:sabnzbd inject_conf.py /opt/inject_conf.py
RUN chmod +x /opt/entrypoint.sh

EXPOSE 8000

ENTRYPOINT [ "/opt/entrypoint.sh" ]
