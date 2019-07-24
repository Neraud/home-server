#!/usr/bin/env bash

echo ""
echo "Deleting ElasticSearch StatefulSet"
su user -c "kubectl --namespace=logging delete statefulsets elasticsearch"

echo ""
echo "Deleting Kibana Deployment"
su user -c "kubectl --namespace=logging delete deployments kibana"

echo ""
echo "Mount Elasticsearch volume"
mkdir -p /data/volumes/elasticsearch-data
mount -t glusterfs master-1:/elasticsearch-data /data/volumes/elasticsearch-data

echo ""
echo "Wait to be sure Elasticsearch is stopped"
sleep 5
rm -Rf /data/volumes/elasticsearch-data/*

echo ""
echo "Provision ElasticSearch & Kibana"
bash /opt/provision/vagrant/ansible_provisioning.sh --tags kubernetes-app-logging-elasticsearch,kubernetes-app-logging-kibana
