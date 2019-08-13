#!/usr/bin/env bash

echo ""
echo "Deleting Prometheus Operator deployment"
su user -c "kubectl --namespace=monitoring delete deployments prometheus-operator"

echo "Deleting Prometheus Statefulset"
su user -c "kubectl --namespace=monitoring delete statefulsets prometheus-k8s"

echo "Deleting AlertManager Statefulset"
su user -c "kubectl --namespace=monitoring delete statefulsets alertmanager-main"

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
