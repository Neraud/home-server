#!/usr/bin/env sh

docker build --tag kube-prometheus-generator .
docker run --rm -it -v $(pwd)/out:/out kube-prometheus-generator

# Intall convert requirements
pip3 install pyyaml

# Now that mixins are generated, we "convert" them to the way we store them in our repo.
# The output has the same folder structure as the target to allow for easy diffs.
./convert.sh
