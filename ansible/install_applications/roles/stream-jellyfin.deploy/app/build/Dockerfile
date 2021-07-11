ARG from_image
FROM $from_image

ARG jellyfin_plugins_anidb_url
ARG jellyfin_plugins_anilist_url
ARG jellyfin_plugins_anisearch_url
ARG jellyfin_plugins_ldapauth_url
ARG jellyfin_plugins_thetvdb_url

RUN echo "Create jellyfin user" && \
    groupadd -g 1000 jellyfin && \
    useradd -s /bin/sh -g jellyfin -u 1000 jellyfin

# To use HW acceleration
RUN echo "Create render group" && \
    groupadd -g 107 render && \
    usermod -a -G render jellyfin

RUN echo "Install plugins requirements" && \
    apt-get update && \
    apt-get install -y zip curl && \
    rm -rf /var/lib/apt/lists/*

RUN echo "Install jellyfin-plugin-anidb" && \
    mkdir -p "/opt/jellyfin/plugins/AniDB" && \
    curl -L $jellyfin_plugins_anidb_url -o /opt/jellyfin/plugins/jellyfin-plugin-anidb.zip && \
    unzip /opt/jellyfin/plugins/jellyfin-plugin-anidb.zip -d "/opt/jellyfin/plugins/AniDB" && \
    rm /opt/jellyfin/plugins/jellyfin-plugin-anidb.zip

RUN echo "Install jellyfin-plugin-anilist" && \
    mkdir -p "/opt/jellyfin/plugins/AniList" && \
    curl -L $jellyfin_plugins_anilist_url -o /opt/jellyfin/plugins/jellyfin-plugin-anilist.zip && \
    unzip /opt/jellyfin/plugins/jellyfin-plugin-anilist.zip -d "/opt/jellyfin/plugins/AniList" && \
    rm /opt/jellyfin/plugins/jellyfin-plugin-anilist.zip

RUN echo "Install jellyfin-plugin-anisearch" && \
    mkdir -p "/opt/jellyfin/plugins/AniSearch" && \
    curl -L $jellyfin_plugins_anisearch_url -o /opt/jellyfin/plugins/jellyfin-plugin-anisearch.zip && \
    unzip /opt/jellyfin/plugins/jellyfin-plugin-anisearch.zip -d "/opt/jellyfin/plugins/AniSearch" && \
    rm /opt/jellyfin/plugins/jellyfin-plugin-anisearch.zip

RUN echo "Install jellyfin-plugin-ldapauth" && \
    mkdir -p "/opt/jellyfin/plugins/LDAP Authentication" && \
    curl -L $jellyfin_plugins_ldapauth_url -o /opt/jellyfin/plugins/jellyfin-plugin-ldapauth.zip && \
    unzip /opt/jellyfin/plugins/jellyfin-plugin-ldapauth.zip -d "/opt/jellyfin/plugins/LDAP Authentication" && \
    rm /opt/jellyfin/plugins/jellyfin-plugin-ldapauth.zip

RUN echo "Install jellyfin-plugin-thetvdb" && \
    mkdir -p "/opt/jellyfin/plugins/TheTVDB" && \
    curl -L $jellyfin_plugins_thetvdb_url -o /opt/jellyfin/plugins/jellyfin-plugin-thetvdb.zip && \
    unzip /opt/jellyfin/plugins/jellyfin-plugin-thetvdb.zip -d "/opt/jellyfin/plugins/TheTVDB" && \
    rm /opt/jellyfin/plugins/jellyfin-plugin-thetvdb.zip

ADD --chown=jellyfin:jellyfin entrypoint.sh /opt/jellyfin/entrypoint.sh
RUN chmod +x /opt/jellyfin/entrypoint.sh

USER jellyfin
ENTRYPOINT [ "/opt/jellyfin/entrypoint.sh" ]
