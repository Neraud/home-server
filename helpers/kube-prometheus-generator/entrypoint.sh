#!/usr/bin/env sh

echo "Kube-Prometheus"
mkdir -p /opt/kube-prometheus
cd /opt/kube-prometheus

echo " - installing requirements ..."
jb init
jb install github.com/coreos/kube-prometheus/jsonnet/kube-prometheus@main

mkdir -p /out/kube-prometheus
mkdir -p /out/kube-prometheus/setup

# TODO Temp ugly workaround, waiting for a proper fix in kube-prometheus
echo " - workaround kubernetes-mixin cleanup"
find . -type f -exec grep -l "github.com/kubernetes-monitoring/kubernetes-mixin/alerts/add-runbook-links.libsonnet" {} \; | while read file; do
    echo "  = $file"
    sed -i "s|github.com/kubernetes-monitoring/kubernetes-mixin/alerts/add-runbook-links.libsonnet|github.com/kubernetes-monitoring/kubernetes-mixin/lib/add-runbook-links.libsonnet|g" $file
done

echo " - generating kube-prometheus ..."
jsonnet -J vendor -m /out/kube-prometheus config.jsonnet | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml; rm -f {}' -- {}

chmod -R 777 /out
