#!/usr/bin/env bash

# Script adapted from https://gitea.com/gitea/helm-chart/src/branch/master/templates/gitea/init.yaml

set -euo pipefail

# Connection retry inspired by https://gist.github.com/dublx/e99ea94858c07d2ca6de
function test_db_connection() {
  local RETRY=0
  local MAX=30
  local DB_HOST=$(echo ${GITEA__database__HOST} | cut -d':' -f1)
  local DB_PORT=$(echo ${GITEA__database__HOST} | cut -d':' -f2)
  echo 'Wait for database to become available...'
  until [ "${RETRY}" -ge "${MAX}" ]; do
    nc -vz -w2 ${DB_HOST} ${DB_PORT} && break
    RETRY=$[${RETRY}+1]
    echo "...not ready yet (${RETRY}/${MAX})"
    sleep 3
  done
  if [ "${RETRY}" -ge "${MAX}" ]; then
    echo "Database not reachable after '${MAX}' attempts!"
    exit 1
  fi
}

test_db_connection

echo '==== BEGIN GITEA CONFIGURATION ===='

gitea --config ${GITEA_APP_INI} migrate migrate


function configure_admin_user() {
  local ACCOUNT_ID=$(gitea --config ${GITEA_APP_INI} admin user list --admin | grep -e "\s\+${GITEA_ADMIN_USERNAME}\s\+" | awk -F " " "{printf \$1}")
  if [[ -z "${ACCOUNT_ID}" ]]; then
    echo "No admin user '${GITEA_ADMIN_USERNAME}' found. Creating now..."
    gitea --config ${GITEA_APP_INI} admin user create --admin --username "${GITEA_ADMIN_USERNAME}" --password "${GITEA_ADMIN_PASSWORD}" --email ${GITEA_ADMIN_EMAIL} --must-change-password=false
    echo '...created.'
  else
    echo "Admin account '${GITEA_ADMIN_USERNAME}' already exist. Running update to sync password..."
    gitea --config ${GITEA_APP_INI} admin user change-password --username "${GITEA_ADMIN_USERNAME}" --password "${GITEA_ADMIN_PASSWORD}"
    echo '...password sync done.'
  fi
}

if [[ -n "${GITEA_ADMIN_USERNAME}" ]]; then
    configure_admin_user
else
    echo 'no admin account configured... skipping.'
fi

function configure_ldap() {
  local GITEA_AUTH_ID=$(gitea --config ${GITEA_APP_INI} admin auth list --vertical-bars | grep -E "\|${GITEA_LDAP_NAME}\s+\|" | grep -iE '\|LDAP \(via BindDN\)\s+\|' | awk -F " "  "{print \$1}")
  if [[ -z "${GITEA_AUTH_ID}" ]]; then
    echo "No ldap configuration found with name '${GITEA_LDAP_NAME}'. Installing it now..."
    gitea --config ${GITEA_APP_INI} admin auth add-ldap \
        --name ${GITEA_LDAP_NAME} \
        --security-protocol ${GITEA_LDAP_SECURITY_PROTOCOL} \
        --host ${GITEA_LDAP_HOST} \
        --port ${GITEA_LDAP_PORT} \
        --bind-dn ${GITEA_LDAP_BIND_DN} \
        --bind-password ${GITEA_LDAP_BIND_PASSWORD} \
        --user-search-base ${GITEA_LDAP_USER_SEARCH_BASE} \
        --user-filter ${GITEA_LDAP_USER_FILTER} \
        --admin-filter ${GITEA_LDAP_ADMIN_FILTER} \
        --allow-deactivate-all \
        --username-attribute ${GITEA_LDAP_USERNAME_ATTRIBUTE} \
        --email-attribute ${GITEA_LDAP_EMAIL_ATTRIBUTE}
        
    echo '...installed.'
  else
    echo "Existing ldap configuration with name '${GITEA_LDAP_NAME}': '${GITEA_AUTH_ID}'. Running update to sync settings..."
    gitea --config ${GITEA_APP_INI} admin auth update-ldap --id "${GITEA_AUTH_ID}" \
        --name ${GITEA_LDAP_NAME} \
        --security-protocol ${GITEA_LDAP_SECURITY_PROTOCOL} \
        --host ${GITEA_LDAP_HOST} \
        --port ${GITEA_LDAP_PORT} \
        --bind-dn ${GITEA_LDAP_BIND_DN} \
        --bind-password ${GITEA_LDAP_BIND_PASSWORD} \
        --user-search-base ${GITEA_LDAP_USER_SEARCH_BASE} \
        --user-filter ${GITEA_LDAP_USER_FILTER} \
        --admin-filter ${GITEA_LDAP_ADMIN_FILTER} \
        --allow-deactivate-all \
        --username-attribute ${GITEA_LDAP_USERNAME_ATTRIBUTE} \
        --email-attribute ${GITEA_LDAP_EMAIL_ATTRIBUTE}
    echo '...sync settings done.'
  fi
}

if [[ -n "${GITEA_LDAP_NAME}" ]]; then
    configure_ldap
else
    echo 'no ldap configuration... skipping.'
fi

echo "Starting Gitea"
exec /usr/local/bin/gitea -c ${GITEA_APP_INI} web
