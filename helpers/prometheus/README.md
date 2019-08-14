
# Prometheus

## snapshot_metrics

This is a simple tool to snapshot the metrics exposed by all prometheus targets.

### Requirement

This script requires `prometheus_client`, which can be installed with :
```
apt-get install python3-pip python3-setuptools python3-dev
pip3 install prometheus_client
```

### Usage

Simply run the `snapshot_metrics.py` script.

The target list will be exported in `snapshot_metrics_out/targets.json`.
Metrics will be exported in files : `snapshot_metrics_out/[job]_[instance].prom`
