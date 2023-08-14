# Ingress NGINX

## Manifest source

`deploy.yaml` is fetched from https://github.com/kubernetes/ingress-nginx/blob/controller-v1.7.0/deploy/static/provider/baremetal/deploy.yaml

Remember to delete the jobs before updating:

```bash
kubectl --namespace=ingress-nginx delete job ingress-nginx-admission-create
kubectl --namespace=ingress-nginx delete job ingress-nginx-admission-patch
```
