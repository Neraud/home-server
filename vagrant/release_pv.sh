#!/usr/bin/env bash

pv_name="$1"

echo "Removing claim on ${pv_name}"
kubectl patch pv ${pv_name} -p '{"spec":{"claimRef": null}}'
