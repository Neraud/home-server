FROM ghcr.io/paperless-ngx/paperless-ngx:2.13.2

# if necessary, install lang packages (https://packages.debian.org/search?keywords=tesseract-ocr-)
#RUN apt-get update && \
#    apt-get install -y tesseract-ocr-eng && \
#    rm -rf /var/lib/apt/lists/*

ENV PAPERLESS_SUPERVISORD_WORKING_DIR=/tmp

USER paperless
