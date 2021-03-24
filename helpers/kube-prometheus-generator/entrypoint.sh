#!/usr/bin/env sh

echo "Kube-Prometheus"
mkdir -p /opt/kube-prometheus
cd /opt/kube-prometheus

echo " - installing requirements ..."
jb init
jb install github.com/coreos/kube-prometheus/jsonnet/kube-prometheus@main

mkdir -p /out/kube-prometheus
echo " - generating kube-prometheus ..."
jsonnet -J vendor -m /out/kube-prometheus config.jsonnet | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml; rm -f {}' -- {}

chmod -R 777 /out
