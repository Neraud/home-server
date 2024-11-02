# Promtail

## Manifest source

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm template promtail grafana/promtail --namespace=logging-promtail --values values.yaml --version 6.16.6 > deploy/promtail.yaml
```

## Find latest version

```bash
helm search repo grafana/promtail
```

## Chart source

Helm source repo: <https://github.com/grafana/helm-charts/tree/main/charts/promtail>
