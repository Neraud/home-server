#!/bin/sh
set -eu

# Copied from https://github.com/nextcloud/docker/blob/8afd97014cc3445e888a165f8c2d16af7ed036aa/28/apache/entrypoint.sh
# Changes :
# - use /usr/src/nextcloud instead of /var/www/html
# - use config/version-installed.php instead of version.php to check currently installed version
# - do not rsync nextcloud sources (/usr/src/nextcloud is already the docroot in our custom image)
# - move php conf files from /usr/local/etc/php/conf.d under /tmp
# - move install lock under /tmp
# - Add support for LDAP env var
# - deploy custom configurations
# - add supervisord (to run cron)
# - (add a few logs)

# Prepare folders under /tmp
mkdir -p ${PHP_INI_SCAN_DIR}
cp -R /usr/local/etc/php/conf.d/* ${PHP_INI_SCAN_DIR}/
mkdir -p /tmp/log/supervisord
mkdir -p /tmp/run/supervisord


# version_greater A B returns whether A > B
version_greater() {
    [ "$(printf '%s\n' "$@" | sort -t '.' -n -k1,1 -k2,2 -k3,3 -k4,4 | head -n 1)" != "$1" ]
}

# return true if specified directory is empty
directory_empty() {
    [ -z "$(ls -A "$1/")" ]
}

run_as() {
    if [ "$(id -u)" = 0 ]; then
        su -p www-data -s /bin/sh -c "$1"
    else
        sh -c "$1"
    fi
}

# Execute all executable files in a given directory in alphanumeric order
run_path() {
    local hook_folder_path="/docker-entrypoint-hooks.d/$1"
    local return_code=0

    if ! [ -d "${hook_folder_path}" ]; then
        echo "=> Skipping the folder \"${hook_folder_path}\", because it doesn't exist"
        return 0
    fi

    echo "=> Searching for scripts (*.sh) to run, located in the folder: ${hook_folder_path}"

    (
        find "${hook_folder_path}" -maxdepth 1 -iname '*.sh' '(' -type f -o -type l ')' -print | sort | while read -r script_file_path; do
            if ! [ -x "${script_file_path}" ]; then
                echo "==> The script \"${script_file_path}\" was skipped, because it didn't have the executable flag"
                continue
            fi

            echo "==> Running the script (cwd: $(pwd)): \"${script_file_path}\""

            run_as "${script_file_path}" || return_code="$?"

            if [ "${return_code}" -ne "0" ]; then
                echo "==> Failed at executing \"${script_file_path}\". Exit code: ${return_code}"
                exit 1
            fi

            echo "==> Finished the script: \"${script_file_path}\""
        done
    )
}

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    local varValue=$(env | grep -E "^${var}=" | sed -E -e "s/^${var}=//")
    local fileVarValue=$(env | grep -E "^${fileVar}=" | sed -E -e "s/^${fileVar}=//")
    if [ -n "${varValue}" ] && [ -n "${fileVarValue}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    if [ -n "${varValue}" ]; then
        export "$var"="${varValue}"
    elif [ -n "${fileVarValue}" ]; then
        export "$var"="$(cat "${fileVarValue}")"
    elif [ -n "${def}" ]; then
        export "$var"="$def"
    fi
    unset "$fileVar"
}

if expr "$1" : "apache" 1>/dev/null; then
    if [ -n "${APACHE_DISABLE_REWRITE_IP+x}" ]; then
        a2disconf remoteip
    fi
fi

if expr "$1" : "apache" 1>/dev/null || [ "$1" = "php-fpm" ] || [ "${NEXTCLOUD_UPDATE:-0}" -eq 1 ]; then
    if [ -n "${REDIS_HOST+x}" ]; then

        echo "Configuring Redis as session handler"
        {
            file_env REDIS_HOST_PASSWORD
            echo 'session.save_handler = redis'
            # check if redis host is an unix socket path
            if [ "$(echo "$REDIS_HOST" | cut -c1-1)" = "/" ]; then
              if [ -n "${REDIS_HOST_PASSWORD+x}" ]; then
                echo "session.save_path = \"unix://${REDIS_HOST}?auth=${REDIS_HOST_PASSWORD}\""
              else
                echo "session.save_path = \"unix://${REDIS_HOST}\""
              fi
            # check if redis password has been set
            elif [ -n "${REDIS_HOST_PASSWORD+x}" ]; then
                echo "session.save_path = \"tcp://${REDIS_HOST}:${REDIS_HOST_PORT:=6379}?auth=${REDIS_HOST_PASSWORD}\""
            else
                echo "session.save_path = \"tcp://${REDIS_HOST}:${REDIS_HOST_PORT:=6379}\""
            fi
            echo "redis.session.locking_enabled = 1"
            echo "redis.session.lock_retries = -1"
            # redis.session.lock_wait_time is specified in microseconds.
            # Wait 10ms before retrying the lock rather than the default 2ms.
            echo "redis.session.lock_wait_time = 10000"
        } > ${PHP_INI_SCAN_DIR}/redis-session.ini
    fi

    installed_version="0.0.0.0"
    if [ -f /usr/src/nextcloud/config/version-installed.php ]; then
        # shellcheck disable=SC2016
        installed_version="$(php -r 'require "/usr/src/nextcloud/config/version-installed.php"; echo implode(".", $OC_Version);')"
    fi
    echo "Installed version : $installed_version"
    # shellcheck disable=SC2016
    image_version="$(php -r 'require "/usr/src/nextcloud/version.php"; echo implode(".", $OC_Version);')"

    if version_greater "$installed_version" "$image_version"; then
        echo "Can't start Nextcloud because the version of the data ($installed_version) is higher than the docker image version ($image_version) and downgrading is not supported. Are you sure you have pulled the newest image version?"
        exit 1
    fi

    if version_greater "$image_version" "$installed_version"; then
        echo "Initializing nextcloud $image_version ..."
        if [ "$installed_version" != "0.0.0.0" ]; then
            if [ "${image_version%%.*}" -gt "$((${installed_version%%.*} + 1))" ]; then
                echo "Can't start Nextcloud because upgrading from $installed_version to $image_version is not supported."
                echo "It is only possible to upgrade one major version at a time. For example, if you want to upgrade from version 14 to 16, you will have to upgrade from version 14 to 15, then from 15 to 16."
                exit 1
            fi
            echo "Upgrading nextcloud from $installed_version ..."
            run_as 'php /usr/src/nextcloud/occ app:list' | sed -n "/Enabled:/,/Disabled:/p" > /tmp/list_before
        fi
        if [ "$(id -u)" = 0 ]; then
            rsync_options="-rlDog --chown www-data:root"
        else
            rsync_options="-rlD"
        fi

        # If another process is syncing the html folder, wait for
        # it to be done, then escape initalization.
        # You need to define the NEXTCLOUD_INIT_LOCK environment variable
        lock=/tmp/nextcloud-init-sync.lock
        count=0
        limit=10

        if [ -f "$lock" ] && [ -n "${NEXTCLOUD_INIT_LOCK+x}" ]; then
            until [ ! -f "$lock" ] || [ "$count" -gt "$limit" ]
            do
                count=$((count+1))
                wait=$((count*10))
                echo "Another process is initializing Nextcloud. Waiting $wait seconds..."
                sleep $wait
            done
            if [ "$count" -gt "$limit" ]; then
                echo "Timeout while waiting for an ongoing initialization"
                exit 1
            fi
            echo "The other process is done, assuming complete initialization"
        else
            # Prevent multiple images syncing simultaneously
            touch $lock
            #rsync $rsync_options --delete --exclude-from=/upgrade.exclude /usr/src/nextcloud/ /usr/src/nextcloud/

            for dir in config data custom_apps themes; do
                if [ ! -d "/usr/src/nextcloud/$dir" ] || directory_empty "/usr/src/nextcloud/$dir"; then
                    echo " - copying $dir"
                    rsync $rsync_options /usr/src/nextcloud_bak/$dir/ /usr/src/nextcloud/$dir
                fi
            done
            echo " - copying version.php"
            #rsync $rsync_options --include '/version.php' --exclude '/*' /usr/src/nextcloud/ /usr/src/nextcloud/
            cp /usr/src/nextcloud/version.php /usr/src/nextcloud/config/version-installed.php
            if [ "$(id -u)" = 0 ]; then
                chown www-data:root /usr/src/nextcloud/config/version-installed.php
            fi

            # Install
            if [ "$installed_version" = "0.0.0.0" ]; then
                echo "New nextcloud instance"

                file_env NEXTCLOUD_ADMIN_PASSWORD
                file_env NEXTCLOUD_ADMIN_USER

                if [ -n "${NEXTCLOUD_ADMIN_USER+x}" ] && [ -n "${NEXTCLOUD_ADMIN_PASSWORD+x}" ]; then
                    # shellcheck disable=SC2016
                    install_options='-n --admin-user "$NEXTCLOUD_ADMIN_USER" --admin-pass "$NEXTCLOUD_ADMIN_PASSWORD"'
                    if [ -n "${NEXTCLOUD_DATA_DIR+x}" ]; then
                        # shellcheck disable=SC2016
                        install_options=$install_options' --data-dir "$NEXTCLOUD_DATA_DIR"'
                    fi

                    file_env MYSQL_DATABASE
                    file_env MYSQL_PASSWORD
                    file_env MYSQL_USER
                    file_env POSTGRES_DB
                    file_env POSTGRES_PASSWORD
                    file_env POSTGRES_USER

                    install=false
                    if [ -n "${SQLITE_DATABASE+x}" ]; then
                        echo "Installing with SQLite database"
                        # shellcheck disable=SC2016
                        install_options=$install_options' --database-name "$SQLITE_DATABASE"'
                        install=true
                    elif [ -n "${MYSQL_DATABASE+x}" ] && [ -n "${MYSQL_USER+x}" ] && [ -n "${MYSQL_PASSWORD+x}" ] && [ -n "${MYSQL_HOST+x}" ]; then
                        echo "Installing with MySQL database"
                        # shellcheck disable=SC2016
                        install_options=$install_options' --database mysql --database-name "$MYSQL_DATABASE" --database-user "$MYSQL_USER" --database-pass "$MYSQL_PASSWORD" --database-host "$MYSQL_HOST"'
                        install=true
                    elif [ -n "${POSTGRES_DB+x}" ] && [ -n "${POSTGRES_USER+x}" ] && [ -n "${POSTGRES_PASSWORD+x}" ] && [ -n "${POSTGRES_HOST+x}" ]; then
                        echo "Installing with PostgreSQL database"
                        # shellcheck disable=SC2016
                        install_options=$install_options' --database pgsql --database-name "$POSTGRES_DB" --database-user "$POSTGRES_USER" --database-pass "$POSTGRES_PASSWORD" --database-host "$POSTGRES_HOST"'
                        install=true
                    fi

                    if [ "$install" = true ]; then
                        run_path pre-installation

                        echo "Starting nextcloud installation"
                        max_retries=10
                        try=0
                        until run_as "php /usr/src/nextcloud/occ maintenance:install $install_options" || [ "$try" -gt "$max_retries" ]
                        do
                            echo "Retrying install..."
                            try=$((try+1))
                            sleep 10s
                        done
                        if [ "$try" -gt "$max_retries" ]; then
                            echo "Installing of nextcloud failed!"
                            exit 1
                        fi
                        if [ -n "${NEXTCLOUD_TRUSTED_DOMAINS+x}" ]; then
                            echo "Setting trusted domains…"
                            NC_TRUSTED_DOMAIN_IDX=1
                            for DOMAIN in $NEXTCLOUD_TRUSTED_DOMAINS ; do
                                DOMAIN=$(echo "$DOMAIN" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
                                run_as "php /usr/src/nextcloud/occ config:system:set trusted_domains $NC_TRUSTED_DOMAIN_IDX --value=$DOMAIN"
                                NC_TRUSTED_DOMAIN_IDX=$(($NC_TRUSTED_DOMAIN_IDX+1))
                            done
                        fi

                        run_path post-installation
                    else
                        echo "Please run the web-based installer on first connect!"
                    fi
                fi
            # Upgrade
            else
                run_path pre-upgrade

                run_as 'php /usr/src/nextcloud/occ upgrade'

                run_as 'php /usr/src/nextcloud/occ app:list' | sed -n "/Enabled:/,/Disabled:/p" > /tmp/list_after
                echo "The following apps have been disabled:"
                diff /tmp/list_before /tmp/list_after | grep '<' | cut -d- -f2 | cut -d: -f1
                rm -f /tmp/list_before /tmp/list_after

                run_path post-upgrade
            fi

            # Initialization done, reset lock
            rm $lock
            echo "Initializing finished"
        fi
    fi

    # Update htaccess after init if requested
    if [ -n "${NEXTCLOUD_INIT_HTACCESS+x}" ]; then
        run_as 'php /usr/src/nextcloud/occ maintenance:update:htaccess'
    fi

    run_path before-starting
fi

# Deploy custom configurations after Nextcloud is installed
#We can't simply drop those files in hte config dir directly, because if config is not empty the first time this container starts, nextcloud is never installed.
echo "Deploy custom configurations"
if [ -d /usr/src/nextcloud/config_custom ] ; then
    cp -v /usr/src/nextcloud/config_custom/* /usr/src/nextcloud/config/
fi


if [ -n "${NEXTCLOUD_LDAP_HOST:-}" ]; then
    echo "Configure LDAP"
    echo " - enable user_ldap app"
    run_as "php /usr/src/nextcloud/occ app:enable user_ldap"

    echo " - search for config"
    if run_as "php /usr/src/nextcloud/occ ldap:show-config s01" 1> /dev/null ; then
        echo "(config s01 already exists)"
    else
        echo " - creating new config"
        run_as "php /usr/src/nextcloud/occ ldap:create-empty-config"
    fi
    
    echo " - set config"
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapHost \"${NEXTCLOUD_LDAP_HOST}\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapPort \"${NEXTCLOUD_LDAP_PORT}\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapConfigurationActive \"1\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapAgentName \"${NEXTCLOUD_LDAP_AGENT_NAME}\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapAgentPassword \"${NEXTCLOUD_LDAP_AGENT_PASSWORD}\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapBase \"${NEXTCLOUD_LDAP_BASE}\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapBaseUsers \"${NEXTCLOUD_LDAP_BASE_USERS}\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapUserDisplayName \"${NEXTCLOUD_LDAP_DISPLAY_NAME}\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapEmailAttribute \"${NEXTCLOUD_LDAP_EMAIL_ATTRIBUTE}\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapUserFilter \"${NEXTCLOUD_LDAP_USER_FILTER}\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapLoginFilter \"${NEXTCLOUD_LDAP_LOGIN_FILTER}\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapBaseGroups \"${NEXTCLOUD_LDAP_BASE_GROUPS}\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 ldapGroupFilter \"${NEXTCLOUD_LDAP_GROUP_FILTER}\""
    run_as "php /usr/src/nextcloud/occ ldap:set-config s01 turnOffCertCheck \"${NEXTCLOUD_LDAP_IGNORE_SSL_CERT:-0}\""
fi

echo "Enable default applications"
run_as "php /usr/src/nextcloud/occ app:enable admin_audit"
run_as "php /usr/src/nextcloud/occ app:enable calendar"
run_as "php /usr/src/nextcloud/occ app:enable contacts"
run_as "php /usr/src/nextcloud/occ app:enable notes"
run_as "php /usr/src/nextcloud/occ app:enable tasks"
run_as "php /usr/src/nextcloud/occ app:enable twofactor_totp"

echo "Configure background-job to cron"
run_as "php /usr/src/nextcloud/occ background:cron"

echo "Start nextcloud"
exec "$@"
