FROM docker.io/library/python:3.11.2-slim-bullseye

# Install requirements
# non-free is needed for unrar
RUN sed -i "s|deb http://deb.debian.org/debian bullseye main|deb http://deb.debian.org/debian bullseye main non-free|g" /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y curl p7zip-full par2 unrar unzip && \
    apt-get install -y ffmpeg && \
    rm -rf /var/lib/apt/lists/*
#RUN apk add --no-cache openssl unrar unzip p7zip ffmpeg libgomp

RUN echo "Creating sabnzbd user" && \
    groupadd --gid 1000 sabnzbd && \
    useradd --create-home --gid sabnzbd --uid 1000 sabnzbd

# Install sabnzbd
RUN mkdir -p /opt/sabnzbd && \
    cd /opt/sabnzbd && \
    curl -sL https://github.com/sabnzbd/sabnzbd/archive/3.7.2.tar.gz | tar xz --strip-components=1 && \
    pip install -r /opt/sabnzbd/requirements.txt && \
    python tools/make_mo.py

VOLUME [ "/opt/sabnzbd-data" ]
RUN chown -R sabnzbd:sabnzbd /opt/sabnzbd && \
    mkdir -p /opt/sabnzbd-data && \
    chown -R sabnzbd:sabnzbd /opt/sabnzbd-data && \
    mkdir -p /opt/nzbToMedia && \
    chown -R sabnzbd:sabnzbd /opt/nzbToMedia

USER sabnzbd

# Install nzbToMedia
RUN cd /opt/nzbToMedia && \
    curl -sL https://github.com/clinton-hall/nzbToMedia/archive/12.1.10.tar.gz | tar xz --strip-components=1 && \
    ln -s /opt/sabnzbd-data/nzbtomedia/autoProcessMedia.cfg /opt/nzbToMedia/autoProcessMedia.cfg && \
    ln -s /opt/sabnzbd-data/nzbtomedia/autoProcessMedia.cfg.old /opt/nzbToMedia/autoProcessMedia.cfg.old && \
    ln -s /opt/sabnzbd-data/nzbtomedia/nzbtomedia.db /opt/nzbToMedia/nzbtomedia.db && \
    ln -s /opt/sabnzbd-data/nzbtomedia/logs /opt/nzbToMedia/logs

ADD --chown=sabnzbd:sabnzbd entrypoint.sh /opt/entrypoint.sh
ADD --chown=sabnzbd:sabnzbd inject_conf.py /opt/inject_conf.py
RUN chmod +x /opt/entrypoint.sh

EXPOSE 8000

ENTRYPOINT [ "/opt/entrypoint.sh" ]
