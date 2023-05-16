#!/bin/bash

set -euo pipefail

function usage() {
  echo "usage: $0 <ssh_conf_path> <ssh_key_path> <source> <destination> <rsync_extra_params>"
}

ssh_conf_path="$1"
ssh_key_path="$2"
source="$3"
destination="$4"
rsync_extra_params="$5"

if [ -z "$ssh_conf_path" ]; then
  echo "Missing mandatory parameter ssh_conf_path"
  usage
  exit 1
elif [ ! -f "$ssh_conf_path" ]; then
  echo "ssh_conf_path ($ssh_conf_path) is not a file"
  usage
  exit 1
fi

if [ -z "$ssh_key_path" ]; then
  echo "Missing mandatory parameter ssh_key_path"
  usage
  exit 1
elif [ ! -f "$ssh_key_path" ]; then
  echo "ssh_key_path ($ssh_key_path) is not a file"
  usage
  exit 1
fi

if [ -z "$source" ]; then
  echo "Missing mandatory parameter source"
  usage
  exit 1
fi

if [ -z "$destination" ]; then
  echo "Missing mandatory parameter destination"
  usage
  exit 1
fi

echo "Rsyncing files from $source"
rsync -ave "ssh -F $ssh_conf_path -i $ssh_key_path" $rsync_extra_params "$source" "$destination"
