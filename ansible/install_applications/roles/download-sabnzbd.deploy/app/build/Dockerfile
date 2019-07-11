ARG from_image
FROM $from_image

RUN echo "Install nzbToMedia dependencies" && \
    apt-get update && \
    apt-get install -y \
        p7zip-full \
        unzip \
        unrar \
        ffmpeg && \
    echo "Install nzbToMedia" && \
    curl -o /tmp/nzbToMedia.tar.gz -L "https://github.com/clinton-hall/nzbToMedia/archive/12.0.10.tar.gz" && \
    mkdir /opt/nzbToMedia && \
    tar xf /tmp/nzbToMedia.tar.gz -C /opt/nzbToMedia --strip-components=1 && \
    echo "Clean up" && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

# add local files
COPY root/ /
