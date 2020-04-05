#!/usr/bin/env bash

namespace="$1"

echo "Removing finalize on ${namespace}"
kubectl get namespace "${namespace}" -o json |
    tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" |
    kubectl replace --raw /api/v1/namespaces/${namespace}/finalize -f -
