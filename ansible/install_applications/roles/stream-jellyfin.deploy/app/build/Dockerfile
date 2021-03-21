ARG from_image
FROM $from_image

ARG jellyfin_plugins_anime_url
ARG jellyfin_plugins_ldapauth_url

RUN echo "Create jellyfin user" && \
    groupadd -g 1000 jellyfin && \
    useradd -s /bin/sh -g jellyfin -u 1000 jellyfin

# To use HW acceleration
RUN echo "Create render group" && \
    groupadd -g 107 render && \
    usermod -a -G render jellyfin

# TODO : remove once we upgrade to 10.7
# See : https://jellyfin.org/posts/jellyfin-apt-key/
RUN echo "Fix jellyfin repo key" && \
    # Ignore errors on update, we know it will fail on jellyfin repo, but we need it to install wget and gnupg2
    apt-get update ; \
    apt-get install -y wget gnupg2 && \
    wget -qO- https://repo.jellyfin.org/jellyfin_team.gpg.key | apt-key add - && \
    apt-get remove -y wget gnupg2 && \
    rm -rf /var/lib/apt/lists/*

RUN echo "Install plugins requirements" && \
    apt-get update && \
    apt-get install -y zip curl && \
    rm -rf /var/lib/apt/lists/*

RUN echo "Install jellyfin-plugin-anime" && \
    mkdir -p "/opt/jellyfin/plugins/Anime" && \
    curl -L $jellyfin_plugins_anime_url -o /opt/jellyfin/plugins/jellyfin-plugin-anime.zip && \
    unzip /opt/jellyfin/plugins/jellyfin-plugin-anime.zip -d "/opt/jellyfin/plugins/Anime" && \
    rm /opt/jellyfin/plugins/jellyfin-plugin-anime.zip

RUN echo "Install jellyfin-plugin-ldapauth" && \
    mkdir -p "/opt/jellyfin/plugins/LDAP Authentication" && \
    curl -L $jellyfin_plugins_ldapauth_url -o /opt/jellyfin/plugins/jellyfin-plugin-ldapauth.zip && \
    unzip /opt/jellyfin/plugins/jellyfin-plugin-ldapauth.zip -d "/opt/jellyfin/plugins/LDAP Authentication" && \
    rm /opt/jellyfin/plugins/jellyfin-plugin-ldapauth.zip

ADD --chown=jellyfin:jellyfin entrypoint.sh /opt/jellyfin/entrypoint.sh
RUN chmod +x /opt/jellyfin/entrypoint.sh

USER jellyfin
ENTRYPOINT [ "/opt/jellyfin/entrypoint.sh" ]
