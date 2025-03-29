#!/usr/bin/env bash

ANSIBLE_VENV_PATH=${1:-/opt/ansible_venv}
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

echo "Install pip3 and virtualenv"
apt-get -q -y install python3-pip python3-venv python3-dev

echo "Install ansible requirements"
# rustc for python cryptography module
apt-get -q -y install rustc libssl-dev rsync

echo "Install ldap requirements"
apt-get -q -y install libsasl2-dev libldap2-dev libssl-dev

echo "Create and activate ansible virtual env"
python3 -m venv --system-site-packages $ANSIBLE_VENV_PATH
source $ANSIBLE_VENV_PATH/bin/activate

echo "Install python ansible requirements"
pip3 install -r $PROJECT_DIR/requirements.txt
