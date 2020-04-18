#!/usr/bin/env bash

echo ""
echo "Deleting ElasticSearch & Kibana namespaces"
su user -c "kubectl delete namespace logging-elasticsearch"
su user -c "kubectl delete namespace logging-kibana"

echo ""
echo "Mount Elasticsearch volume"
ssh 192.168.100.12 "mkdir -p /data/volumes/elasticsearch-k8s-data"
ssh 192.168.100.12 "mount /dev/data_vg/local_elasticsearch-k8s-data /data/volumes/elasticsearch-k8s-data"

echo ""
echo "Wait to be sure Elasticsearch is stopped"
sleep 5

echo ""
echo "Wipe Elasticsearch volumes"
ssh 192.168.100.12 "rm -Rf /data/volumes/elasticsearch-k8s-data/*"

echo ""
echo "Provision ElasticSearch & Kibana"
bash /opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-logging-elasticsearch,kubernetes-app-logging-kibana
