ARG from_image
FROM $from_image

# if necessary, install lang packages (https://packages.debian.org/search?keywords=tesseract-ocr-)
#RUN apt-get update && \
#    apt-get install -y tesseract-ocr-eng && \
#    rm -rf /var/lib/apt/lists/*

ADD supervisor.conf /etc/supervisord.conf
ADD entrypoint.sh /sbin/docker-entrypoint-custom.sh
ENTRYPOINT ["/sbin/docker-entrypoint-custom.sh"]
CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf"]
