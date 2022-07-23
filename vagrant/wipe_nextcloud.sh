#!/usr/bin/env bash

echo ""
echo "Deleting Nextcloud namespace"
su user -c "kubectl delete namespace tool-nextcloud"

echo ""
echo "Release the PVs"
su user -c "kubectl patch pv nextcloud-app -p '{\"spec\":{\"claimRef\": null}}'"
su user -c "kubectl patch pv nextcloud-data -p '{\"spec\":{\"claimRef\": null}}'"
su user -c "kubectl patch pv nextcloud-mysql -p '{\"spec\":{\"claimRef\": null}}'"

echo ""
echo "Mount Nextcloud volumes"
mkdir -p /data/volumes/nextcloud-app
mkdir -p /data/volumes/nextcloud-data
mkdir -p /data/volumes/nextcloud-mysql
mount -t glusterfs master-test-1:/nextcloud-app /data/volumes/nextcloud-app
mount -t glusterfs master-test-1:/nextcloud-data /data/volumes/nextcloud-data
mount -t glusterfs master-test-1:/nextcloud-mysql /data/volumes/nextcloud-mysql

echo ""
echo "Wait to be sure Nextcloud is stopped"
sleep 5

echo ""
echo "Wipe Nextcloud volumes"
rm -Rf /data/volumes/nextcloud-app/*
rm -Rf /data/volumes/nextcloud-data/*
rm -Rf /data/volumes/nextcloud-mysql/*

echo ""
echo "Provision Nextcloud"
bash /opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-tool-nextcloud
