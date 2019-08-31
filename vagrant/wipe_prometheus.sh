#!/usr/bin/env bash

echo ""
echo "Deleting Prometheus"
su user -c "kubectl --namespace=monitoring delete prometheuses --all"

echo "Deleting AlertManager"
su user -c "kubectl --namespace=monitoring delete alertmanagers --all"

echo "Deleting all Prometheus rules"
su user -c "kubectl --namespace=monitoring delete prometheusrules --all"

echo "Deleting all service monitors"
su user -c "kubectl --namespace=monitoring delete servicemonitors --all"

echo ""
echo "Mount Prometheus volumes"
mkdir -p /data/volumes/prometheus-k8s
mount -t glusterfs master-1:/prometheus-k8s /data/volumes/prometheus-k8s

echo ""
echo "Wait to be sure Prometheus is stopped"
sleep 5

echo ""
echo "Wipe Prometheus volumes"
rm -Rf /data/volumes/prometheus-k8s/*

echo ""
echo "Provision Prometheus"
bash /opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-monitoring-prometheus-operator
