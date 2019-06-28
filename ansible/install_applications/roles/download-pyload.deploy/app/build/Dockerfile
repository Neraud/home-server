FROM lsiobase/python:amd64-3.9

# 2019-05-01T20:56:27Z
ARG PYLOAD_RELEASE=1212a684f94856181ad227ff5da140045a95ea8f

ENV PYLOAD_DEFAULT_USER=pyload
ENV PYLOAD_DEFAULT_PASSWORD=pyload
ENV PYLOAD_WEB_PATH=/
ENV PYLOAD_DOWNLOAD_PATH=/downloads

RUN echo "**** install requirements ****" && \
    apk add --no-cache \
        py-crypto \
        py-curl \
        py-imaging \
        tesseract-ocr \
        py-pexpect \
        expect \
        nodejs

RUN \
 echo "**** install app ****" && \
 mkdir -p \
	/app/pyload && \
 if [ -z ${PYLOAD_RELEASE+x} ]; then \
 	PYLOAD_RELEASE=$(curl -sX GET "https://api.github.com/repos/pyload/pyload/commits/stable" \
        | awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
	/tmp/pyload.tar.gz -L \
	"https://github.com/pyload/pyload/archive/${PYLOAD_RELEASE}.tar.gz" && \
 tar xf /tmp/pyload.tar.gz -C \
	/app/pyload --strip-components=1 && \
 echo "**** Cleanup ****" && \
 rm -Rf /tmp/*

# add local files
COPY root/etc/ /etc/
COPY root/app/ /app/

# ports and volumes
EXPOSE 8000
VOLUME /config /downloads
