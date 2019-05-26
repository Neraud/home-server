#!/usr/bin/env sh

docker build --tag mixin-builder .
docker run --rm -it -v $(pwd)/out:/out mixin-builder
