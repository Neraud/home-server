#!/usr/bin/env bash

if [ "$1" == "deploy" ] ; then 
    echo "Deploying debug daemonSet"
    kubectl apply -f /opt/provision/vagrant/daemonSet-debug.yaml
elif [ "$1" == "run" ] ; then
    echo "Running on all pods : ${@:2}"
    kubectl get pods -l "name=debug" -o custom-columns="Name:metadata.name,Node:spec.nodeName" --sort-by=spec.nodeName --no-headers | while read line ; do
        echo "===================================================================================================="
        pod=$(echo $line | cut -d" " -f1)
        node=$(echo $line | cut -d" " -f2)
        echo "$pod on $node"
        kubectl exec $pod -- ${@:2}
        echo "===================================================================================================="
    done
else
    echo "Unknown action $1"
fi

