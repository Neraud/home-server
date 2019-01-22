#!/usr/bin/env bash

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true

ANSIBLE_PLAYBOOK_ARGS="-i /opt/provision/ansible/inventories/vagrant/inventory.yml"
ANSIBLE_PLAYBOOK_ARGS=$ANSIBLE_PLAYBOOK_ARGS" /opt/provision/ansible/site.yml"
#ANSIBLE_PLAYBOOK_ARGS=$ANSIBLE_PLAYBOOK_ARGS" -v"

if [ $# -ne 1 ] ; then
    ANSIBLE_PLAYBOOK_ARGS=$ANSIBLE_PLAYBOOK_ARGS" $*"
fi


ansible-playbook $ANSIBLE_PLAYBOOK_ARGS

if [ -f /etc/kubernetes/admin.conf ] ; then
    diff -q /etc/kubernetes/admin.conf /opt/provision/vagrant/vagrant_kube_admin.conf > /dev/null

    if [ $? -ne 0 ] ; then
        cp /etc/kubernetes/admin.conf /opt/provision/vagrant/vagrant_kube_admin.conf
        echo "Kubenetes config file has been updated in the vagrant folder"
    fi
fi
