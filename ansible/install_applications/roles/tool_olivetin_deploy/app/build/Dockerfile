ARG from_image
FROM $from_image

USER root

# Install requirements
RUN dnf install -y wol \
    && dnf clean all \
    && rm -rf /var/cache/dnf 

# Add custom entrypoint
ADD --chown=olivetin:olivetin entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

USER olivetin

ENTRYPOINT [ "/opt/entrypoint.sh" ]
