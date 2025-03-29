# Loki

## Manifest source

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm template loki grafana/loki --namespace=logging-loki --values values.yaml --version 6.29.0 --skip-tests --api-versions monitoring.coreos.com/v1/ServiceMonitor --api-versions monitoring.coreos.com/v1/PrometheusRule > deploy/loki/loki.yaml
```

## Find latest version

```bash
helm search repo grafana/loki
```

## Chart source

Helm source repo: <https://github.com/grafana/loki/tree/main/production/helm/loki>

## MinIO jobs

Remember to delete the job before updating:

```bash
kubectl --namespace logging-loki delete job init-job
```
