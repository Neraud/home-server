ARG from_image
FROM $from_image

ENV INIT_ASSETS=0

USER root

# Prepare downloaded asset folder
RUN mkdir -p /tmp/homer/downloaded_assets && \
    ln -s /tmp/homer/downloaded_assets /www/assets/download

USER ${UID}:${GID} 

ADD entrypoint.sh /opt/
ENTRYPOINT ["/bin/sh", "/opt/entrypoint.sh"]
