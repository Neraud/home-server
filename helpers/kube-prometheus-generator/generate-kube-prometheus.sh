#!/usr/bin/env sh

mkdir -p out

# Make sure out is writable
chmod -R 777 out

podman build --tag kube-prometheus-generator ./generator
podman run --rm -it -v $(pwd)/generator/config.jsonnet:/opt/kube-prometheus/config.jsonnet -v $(pwd)/out:/out kube-prometheus-generator

podman build --tag kube-prometheus-converter ./converter
podman run --rm -it -v $(pwd)/out:/out kube-prometheus-converter

# swap out to readonly to avoid changing reference files
chmod -R 555 out
