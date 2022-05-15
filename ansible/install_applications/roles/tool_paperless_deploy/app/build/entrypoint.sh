#!/bin/bash

# From https://github.com/jonaswinkler/paperless-ng/blob/master/docker/docker-entrypoint.sh
# Without installs and gosu

set -e

initialize() {
	for dir in export data data/index media media/documents media/documents/originals media/documents/thumbnails; do
		if [[ ! -d "../$dir" ]]; then
			echo "Creating directory ../$dir"
			mkdir ../$dir
		fi
	done

	echo "Creating directory /tmp/paperless"
	mkdir -p /tmp/paperless

    echo "Creating directory under /tmp/supervisord"
    mkdir -p /tmp/supervisord

	set +e
	echo "Adjusting permissions of paperless files. This may take a while."
	chown -R paperless:paperless /tmp/paperless
	find .. -not \( -user paperless -and -group paperless \) -exec chown paperless:paperless {} +
	set -e

	/sbin/docker-prepare.sh
}

echo "Paperless-ng docker container starting..."

initialize

if [[ "$1" != "/"* ]]; then
	echo Executing management command "$@"
	exec python3 manage.py "$@"
else
	echo Executing "$@"
	exec "$@"
fi
