#!/usr/bin/env sh

docker build --tag mixin-builder .
docker run --rm -it -v $(pwd)/out:/out mixin-builder

# Now that mixins are generated, we "convert" them to the way we store them in our repo.
# The output has the same folder structure as the target to allow for easy diffs.
./convert.sh
