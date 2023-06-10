#!/usr/bin/env bash

# Key is configured in the ansible inventory and deployed on the controller by kubernetes_controller_bootstrap
export SOPS_AGE_KEY_FILE=/root/.sops/key.txt

sops --config /opt/provision/apps/vagrant/.sops.yaml $*
