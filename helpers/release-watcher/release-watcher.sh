#!/usr/bin/env bash

if [ ! -d release-watcher ]; then
    git clone https://github.com/Neraud/release-watcher
fi

if [ -d tmp ]; then
    rm -R tmp
fi
mkdir tmp

cd release-watcher
git pull
docker build -t release-watcher-helper .

cd ..
# The vagrant inventory is only used to avoid "AnsibleUndefinedVariable" errors.
# It's not really used, as the only variables we need are set in ansible/install_applications/vars/*.yml
ansible-playbook -i ../../ansible/inventories/vagrant/inventory.ini ./generate-watchers-config.yml

# We could also generate the configuration from a running cluster :
#kubectl --namespace=monitoring get ConfigMap release-watcher-config -o jsonpath='{.data.watchers\.yaml}' >./tmp/watchers.yaml

docker run -v $(pwd):/data release-watcher-helper
