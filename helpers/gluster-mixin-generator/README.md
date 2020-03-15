
# Prometheus mixin generator

## Description

This is a simple tool to generate mixin from :
 * [kube-prometheus](https://github.com/coreos/kube-prometheus)
 * [gluster mixin](https://github.com/gluster/gluster-mixins) project

kube-prometheus includes mixins from other projets like : 
 * [Kubernetes mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin)
 * [Node exporter mixin](https://github.com/prometheus/node_exporter/tree/master/docs/node-mixin)

## Usage

Simply run the `generate-prometheus-mixin.sh` script and the mixin will be generated in an `out` folder
