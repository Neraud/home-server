#!/usr/bin/env sh

podman build --tag kube-prometheus-generator .
podman run --rm -it -v $(pwd)/config.jsonnet:/opt/kube-prometheus/config.jsonnet -v $(pwd)/out:/out kube-prometheus-generator

# Intall convert requirements
pip3 install pyyaml ruamel.yaml

# Now that mixins are generated, we "convert" them to the way we store them in our repo.
# The output has the same folder structure as the target to allow for easy diffs.
./convert.sh
