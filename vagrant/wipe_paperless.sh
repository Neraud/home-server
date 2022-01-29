#!/usr/bin/env bash

echo ""
echo "Deleting Paperless namespace"
su user -c "kubectl delete namespace tool-paperless"

echo ""
echo "Release the PVs"
su user -c "kubectl patch pv paperless-data -p '{\"spec\":{\"claimRef\": null}}'"
su user -c "kubectl patch pv paperless-pgsql -p '{\"spec\":{\"claimRef\": null}}'"
su user -c "kubectl patch pv paperless-redis -p '{\"spec\":{\"claimRef\": null}}'"
su user -c "kubectl patch pv tool-paperless.nfs-papers -p '{\"spec\":{\"claimRef\": null}}'"

echo ""
echo "Mount Paperless volumes"
mkdir -p /data/volumes/paperless-data
mkdir -p /data/volumes/paperless-pgsql
mkdir -p /data/volumes/paperless-redis
mount -t glusterfs master-test-1:/paperless-data /data/volumes/paperless-data
mount -t glusterfs master-test-1:/paperless-pgsql /data/volumes/paperless-pgsql
mount -t glusterfs master-test-1:/paperless-redis /data/volumes/paperless-redis

echo ""
echo "Wait to be sure Paperless is stopped"
sleep 5

echo ""
echo "Wipe Paperless volumes"
rm -Rf /data/volumes/paperless-data/*
rm -Rf /data/volumes/paperless-pgsql/*
rm -Rf /data/volumes/paperless-redis/*

echo ""
echo "Provision Paperless"
bash /opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-tool-paperless
