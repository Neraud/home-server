#!/usr/bin/env bash

application=$1
mode=${2:-diff}

mkdir -p /tmp/kustomize_builds

kustomize_app_path="/opt/provision/apps/vagrant/${application}/deploy"
kustomize_ref_build_path=/tmp/kustomize_builds/${application}.ref.yaml
kustomize_new_build_path=/tmp/kustomize_builds/${application}.new.yaml

if [ ! -d $kustomize_app_path ] ; then
    echo "Application path doesn't exist : $kustomize_app_path"
    exit 1
fi

if [ "$mode" == "ref" ] ; then
    echo "Taking a reference build"
    kustomize build $kustomize_app_path > $kustomize_ref_build_path
elif [ "$mode" == "diff" ] ; then
    echo "Generating a new build"
    kustomize build $kustomize_app_path > $kustomize_new_build_path

    echo "Diff with ref :"
    diff $kustomize_new_build_path $kustomize_ref_build_path
else
    echo "Unknown mode $mode"
    exit 1
fi
