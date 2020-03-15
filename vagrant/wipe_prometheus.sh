#!/usr/bin/env bash

echo ""
echo "Deleting Prometheus namespace"
su user -c "kubectl delete namespace monitoring-prometheus"

echo ""
echo "Deleting the CRDs"
su user -c "kubectl delete --ignore-not-found customresourcedefinitions \
  prometheuses.monitoring.coreos.com \
  servicemonitors.monitoring.coreos.com \
  podmonitors.monitoring.coreos.com \
  alertmanagers.monitoring.coreos.com \
  prometheusrules.monitoring.coreos.com"

echo ""
echo "Release the PVs"
su user -c "kubectl patch pv prometheus-k8s -p '{\"spec\":{\"claimRef\": null}}'"

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
