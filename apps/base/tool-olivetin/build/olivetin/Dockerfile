FROM docker.io/jamesread/olivetin:2024.03.081-amd64

USER root

# Install requirements
RUN microdnf install -y wol \
    && microdnf clean all

# Add custom entrypoint
ADD --chown=olivetin:olivetin entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

USER olivetin

ENTRYPOINT [ "/opt/entrypoint.sh" ]
