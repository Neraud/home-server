ARG from_image
FROM $from_image

ADD --chown=1000:1000 entrypoint.sh /opt/jellyfin/entrypoint.sh
RUN chmod +x /opt/jellyfin/entrypoint.sh
