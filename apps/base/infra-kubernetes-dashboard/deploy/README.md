# Kubernetes Dashboard

## Sources

`manifests.yaml` is generated from the Helm Chart:

```bash
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

helm template kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
    --create-namespace --namespace kubernetes-dashboard \
    --set kong.manager.type=ClusterIP \
    --version 7.1.2 > manifests.yaml
```

## TODO

* kubernetes-dashboard-csrf secret
* tune resources
* fix missing networkpolicies
