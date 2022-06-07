ARG from_image
FROM $from_image

ARG dashboard_icons_repo
ARG dashboard_icons_commit

ENV INIT_ASSETS=0

USER root

# Prepare downloaded asset folder
RUN mkdir -p /tmp/homer/downloaded_assets && \
    ln -s /tmp/homer/downloaded_assets /www/assets/download

# Download icons
RUN mkdir /opt/dashboard-icons && \
    ln -s /opt/dashboard-icons /www/assets/dashboard-icons && \
    wget -q -O- https://github.com/${dashboard_icons_repo}/archive/${dashboard_icons_commit}.tar.gz  | tar xz --strip-components=1 -C /opt/dashboard-icons

USER ${UID}:${GID} 

ADD entrypoint.sh /opt/
ENTRYPOINT ["/bin/sh", "/opt/entrypoint.sh"]
