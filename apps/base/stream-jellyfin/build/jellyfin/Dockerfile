FROM docker.io/jellyfin/jellyfin:10.8.9-amd64

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
    curl -L https://repo.jellyfin.org/releases/plugin/anidb/anidb_7.0.0.0.zip -o /opt/jellyfin/plugins/jellyfin-plugin-anidb.zip && \
    unzip /opt/jellyfin/plugins/jellyfin-plugin-anidb.zip -d "/opt/jellyfin/plugins/AniDB" && \
    rm /opt/jellyfin/plugins/jellyfin-plugin-anidb.zip

RUN echo "Install jellyfin-plugin-anilist" && \
    mkdir -p "/opt/jellyfin/plugins/AniList" && \
    curl -L https://repo.jellyfin.org/releases/plugin/anilist/anilist_5.0.0.0.zip -o /opt/jellyfin/plugins/jellyfin-plugin-anilist.zip && \
    unzip /opt/jellyfin/plugins/jellyfin-plugin-anilist.zip -d "/opt/jellyfin/plugins/AniList" && \
    rm /opt/jellyfin/plugins/jellyfin-plugin-anilist.zip

RUN echo "Install jellyfin-plugin-anisearch" && \
    mkdir -p "/opt/jellyfin/plugins/AniSearch" && \
    curl -L https://repo.jellyfin.org/releases/plugin/anisearch/anisearch_4.0.0.0.zip -o /opt/jellyfin/plugins/jellyfin-plugin-anisearch.zip && \
    unzip /opt/jellyfin/plugins/jellyfin-plugin-anisearch.zip -d "/opt/jellyfin/plugins/AniSearch" && \
    rm /opt/jellyfin/plugins/jellyfin-plugin-anisearch.zip

RUN echo "Install jellyfin-plugin-ldapauth" && \
    mkdir -p "/opt/jellyfin/plugins/LDAP Authentication" && \
    curl -L https://repo.jellyfin.org/releases/plugin/ldap-authentication/ldap-authentication_16.0.0.0.zip -o /opt/jellyfin/plugins/jellyfin-plugin-ldapauth.zip && \
    unzip /opt/jellyfin/plugins/jellyfin-plugin-ldapauth.zip -d "/opt/jellyfin/plugins/LDAP Authentication" && \
    rm /opt/jellyfin/plugins/jellyfin-plugin-ldapauth.zip

RUN echo "Install jellyfin-plugin-thetvdb" && \
    mkdir -p "/opt/jellyfin/plugins/TheTVDB" && \
    curl -L https://repo.jellyfin.org/releases/plugin/thetvdb/thetvdb_9.0.0.0.zip -o /opt/jellyfin/plugins/jellyfin-plugin-thetvdb.zip && \
    unzip /opt/jellyfin/plugins/jellyfin-plugin-thetvdb.zip -d "/opt/jellyfin/plugins/TheTVDB" && \
    rm /opt/jellyfin/plugins/jellyfin-plugin-thetvdb.zip

ADD --chown=jellyfin:jellyfin entrypoint.sh /opt/jellyfin/entrypoint.sh
RUN chmod +x /opt/jellyfin/entrypoint.sh

USER jellyfin
ENTRYPOINT [ "/opt/jellyfin/entrypoint.sh" ]
