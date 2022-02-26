#!/usr/bin/env bash

echo ""
echo "Deleting Gitea namespace"
su user -c "kubectl delete namespace dev-gitea"

echo ""
echo "Release the PVs"
su user -c "kubectl patch pv gitea-data -p '{\"spec\":{\"claimRef\": null}}'"
su user -c "kubectl patch pv gitea-pgsql -p '{\"spec\":{\"claimRef\": null}}'"

echo ""
echo "Mount Gitea volumes"
mkdir -p /data/volumes/gitea-data
mkdir -p /data/volumes/gitea-pgsql
mount -t glusterfs master-test-1:/gitea-data /data/volumes/gitea-data
mount -t glusterfs master-test-1:/gitea-pgsql /data/volumes/gitea-pgsql

echo ""
echo "Wait to be sure Gitea is stopped"
sleep 5

echo ""
echo "Wipe Gitea volumes"
rm -Rf /data/volumes/gitea-data/*
rm -Rf /data/volumes/gitea-pgsql/*

echo ""
echo "Provision Gitea"
bash /opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-dev-gitea
