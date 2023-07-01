#!/bin/sh

touch /var/lib/ntfy/user.db

echo "----------------------------------------------------------------------------------------------------"
echo "User : admin_local"

echo " - create user"
NTFY_PASSWORD=changeme ntfy user add --ignore-exists admin_local

echo " - set password"
NTFY_PASSWORD=changeme ntfy user change-pass admin_local

echo " - set role admin"
ntfy user change-role admin_local admin

echo " - no permissions"

echo "----------------------------------------------------------------------------------------------------"
echo "User : user_local"

echo " - create user"
NTFY_PASSWORD=changeme ntfy user add --ignore-exists user_local

echo " - set password"
NTFY_PASSWORD=changeme ntfy user change-pass user_local

echo " - set role user"
ntfy user change-role user_local user

echo " - permissions :"
echo " --- * read-only"
ntfy access user_local "*" read-only

echo "----------------------------------------------------------------------------------------------------"
echo "User : alertmanager"

echo " - create user"
NTFY_PASSWORD=changeme ntfy user add --ignore-exists alertmanager

echo " - set password"
NTFY_PASSWORD=changeme ntfy user change-pass alertmanager

echo " - set role user"
ntfy user change-role alertmanager user

echo " - permissions :"
echo " --- alerts* write-only"
ntfy access alertmanager "alerts*" write-only

echo "----------------------------------------------------------------------------------------------------"
echo "User : homeassistant"

echo " - create user"
NTFY_PASSWORD=changeme ntfy user add --ignore-exists homeassistant

echo " - set password"
NTFY_PASSWORD=changeme ntfy user change-pass homeassistant

echo " - set role user"
ntfy user change-role homeassistant user

echo " - permissions :"
echo " --- home* write-only"
ntfy access homeassistant "home*" write-only

echo "----------------------------------------------------------------------------------------------------"
echo "List of all existing users and permissions :"
ntfy user list
