#!/usr/bin/env bash

echo ""
echo "Deleting ElasticSearch & Kibana namespaces"
su user -c "kubectl delete namespace logging-elasticsearch"
su user -c "kubectl delete namespace logging-kibana"

echo ""
echo "Release the PVs"
su user -c "kubectl patch pv elasticsearch-k8s-data -p '{\"spec\":{\"claimRef\": null}}'"
su user -c "kubectl patch pv kibana-data -p '{\"spec\":{\"claimRef\": null}}'"

echo ""
echo "Mount Elasticsearch volume"
ssh 192.168.100.12 "mkdir -p /data/volumes/elasticsearch-k8s-data"
ssh 192.168.100.12 "mount /dev/data_vg/local_elasticsearch-k8s-data /data/volumes/elasticsearch-k8s-data"

echo "Mount Kibana volume"
mkdir -p /data/volumes/kibana-data
mount -t glusterfs master-test-1:/kibana-data /data/volumes/kibana-data

echo ""
echo "Wait to be sure Elasticsearch is stopped"
sleep 5

echo ""
echo "Wipe Elasticsearch volumes"
ssh 192.168.100.12 "rm -Rf /data/volumes/elasticsearch-k8s-data/*"
echo "Wipe Kibana volumes"
rm -Rf /data/volumes/kibana-data/*

echo ""
echo "Provision ElasticSearch & Kibana"
bash /opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-logging-elasticsearch,kubernetes-app-logging-kibana
