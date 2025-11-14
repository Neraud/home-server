FROM ghcr.io/olivetin/olivetin:2025.11.11-amd64

USER root

# Install requirements
RUN microdnf install -y wol \
    && microdnf clean all

# Add custom entrypoint
ADD --chown=olivetin:olivetin entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

USER olivetin

ENTRYPOINT [ "/opt/entrypoint.sh" ]
