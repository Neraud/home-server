#!/usr/bin/env bash

echo ""
echo "Deleting OpenLDAP StatefulSet"
su user -c "kubectl delete statefulsets openldap"

echo ""
echo "Mount OpenLDAP volumes"
mkdir -p /data/volumes/openldap-config
mkdir -p /data/volumes/openldap-data
mkdir -p /data/volumes/openldap-run
mount -t glusterfs master-1:/openldap-config /data/volumes/openldap-config
mount -t glusterfs master-1:/openldap-data /data/volumes/openldap-data
mount -t glusterfs master-1:/openldap-run /data/volumes/openldap-run

echo ""
echo "Wait to be sure OpenLDAP is stopped"
sleep 5

echo ""
echo "Mount OpenLDAP volumes"
rm -Rf /data/volumes/openldap-config/*
rm -Rf /data/volumes/openldap-data/*
rm -Rf /data/volumes/openldap-run/*

echo ""
echo "Provision OpenLDAP"
bash /opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-auth-openldap
