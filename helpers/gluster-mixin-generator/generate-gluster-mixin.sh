#!/usr/bin/env sh

docker build --tag gluster-mixin-generator .
docker run --rm -it -v $(pwd)/out:/out gluster-mixin-generator

# Intall convert requirements
pip3 install ruamel.yaml

# Now that mixins are generated, we "convert" them to the way we store them in our repo.
# The output has the same folder structure as the target to allow for easy diffs.
./convert.sh
