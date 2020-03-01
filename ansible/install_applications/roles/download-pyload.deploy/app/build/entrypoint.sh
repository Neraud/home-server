#!/bin/sh

echo "Running the pyLoad user cli to make sure config is initialized"
echo -e "4" | python /opt/pyload/pyLoadCore.py --configdir=/opt/pyload-data --user > /dev/null

if [ "$PYLOAD_DEFAULT_USER" != "" -a "$PYLOAD_DEFAULT_PASSWORD" != "" ] ; then
	echo "Creating / updating user $PYLOAD_DEFAULT_USER"
	# Salt is a 5 digit number : https://github.com/pyload/pyload/blob/e24174964ddaf4b6972c9cd5d8856d8a976fa719/src/pyload/core/database/user_database.py#L46
	salt=$(od -vAn -d -N3 /dev/urandom | tr -d ' \n'  | tail -c 5)

	# Hashed password is a sha1 hash of salt + password : https://github.com/pyload/pyload/blob/e24174964ddaf4b6972c9cd5d8856d8a976fa719/src/pyload/core/database/user_database.py#L14
	hashed_password=$(echo -n "${salt}${PYLOAD_DEFAULT_PASSWORD}" | sha1sum | cut -d" " -f1)

	# Value saved in the DB is salt + hashed_password : https://github.com/pyload/pyload/blob/e24174964ddaf4b6972c9cd5d8856d8a976fa719/src/pyload/core/database/user_database.py#L47
	password_to_save=${salt}${hashed_password}

	sqlite3 /opt/pyload-data/files.db "INSERT OR REPLACE INTO users (id, name, password) VALUES ((SELECT id FROM users WHERE name = '${PYLOAD_DEFAULT_USER}'), '${PYLOAD_DEFAULT_USER}', '${password_to_save}');"
fi

echo "- setting the web path to $PYLOAD_WEB_PATH"
sed -i "s|\"Path Prefix\" *= *.*|\"Path Prefix\" = $PYLOAD_WEB_PATH|" /opt/pyload-data/pyload.conf
echo "- setting download path to $PYLOAD_DOWNLOAD_PATH"
sed -i "s|\"Download Folder\" *= *.*|\"Download Folder\" = $PYLOAD_DOWNLOAD_PATH|" /opt/pyload-data/pyload.conf

python /opt/pyload/pyLoadCore.py --configdir=/opt/pyload-data
