#!/usr/bin/env bash

echo ""
echo "Deleting ElasticSearch & Kibana namespaces"
su user -c "kubectl delete namespace logging-elasticsearch"
su user -c "kubectl delete namespace logging-kibana"

echo ""
echo "Release the PVs"
su user -c "kubectl patch pv elasticsearch-k8s-data -p '{\"spec\":{\"claimRef\": null}}'"

echo ""
echo "Mount Elasticsearch volume"
mkdir -p /data/volumes/elasticsearch-k8s-data
mount -t glusterfs master-1:/elasticsearch-k8s-data /data/volumes/elasticsearch-k8s-data

echo ""
echo "Wait to be sure Elasticsearch is stopped"
sleep 5

echo ""
echo "Wipe Elasticsearch volumes"
rm -Rf /data/volumes/elasticsearch-k8s-data/*

echo ""
echo "Provision ElasticSearch & Kibana"
bash /opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-logging-elasticsearch,kubernetes-app-logging-kibana
