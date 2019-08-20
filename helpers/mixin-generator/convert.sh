#!/usr/bin/env sh

OUT_GENERATED_ROOT=$(pwd)/out
OUT_CONVERTED_ROOT=$(pwd)/out/converted

if [ -d $OUT_CONVERTED_ROOT ]; then
    rm -R $OUT_CONVERTED_ROOT
fi

echo "Converting Kubernetes Prometheus rules"
KUBERNETES_RULES=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/rules/kubernetes_rules.yaml
mkdir -p $(dirname $KUBERNETES_RULES)
cat <<EOF >$KUBERNETES_RULES
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: prometheus-k8s-rules
  namespace: monitoring
  labels:
    app: prometheus
    app-component: prometheus
    prometheus: k8s
    role: alert-rules
spec:
EOF
sed 's/^/  /' $OUT_GENERATED_ROOT/kubernetes-mixin/prometheus_rules.yml >>$KUBERNETES_RULES

echo "Converting Kubernetes Prometheus alerts"
KUBERNETES_ALERTS=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/rules/kubernetes_alerts.yaml
mkdir -p $(dirname $KUBERNETES_ALERTS)
cat <<EOF >$KUBERNETES_ALERTS
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: prometheus-k8s-alerts
  namespace: monitoring
  labels:
    app: prometheus
    app-component: prometheus
    prometheus: k8s
    role: alert-rules
spec:
EOF
sed 's/^/  /' $OUT_GENERATED_ROOT/kubernetes-mixin/prometheus_alerts.yml >>$KUBERNETES_ALERTS

echo "Conert Kubernetes Grafana dashboards"
GRAFANA_DASHBOARD_ROOT=$OUT_CONVERTED_ROOT/monitoring-grafana.deploy/app/config/dashboards
mkdir -p $GRAFANA_DASHBOARD_ROOT
cp $OUT_GENERATED_ROOT/kubernetes-mixin/dashboards/* $GRAFANA_DASHBOARD_ROOT/

echo "Converting Gluster Prometheus rules"
GLUSTER_RULES=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/rules/gluster_rules.yaml
mkdir -p $(dirname $GLUSTER_RULES)
cat <<EOF >$GLUSTER_RULES
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: gluster-rules
  namespace: monitoring
  labels:
    app: gluster
    app-component: gluster
    prometheus: k8s
    role: alert-rules
spec:
EOF
sed 's/^/  /' $OUT_GENERATED_ROOT/gluster-mixin/prometheus_rules.yml >>$GLUSTER_RULES

echo "Converting Gluster Prometheus alerts"
GLUSTER_ALERTS=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/rules/gluster_alerts.yaml
mkdir -p $(dirname $GLUSTER_ALERTS)
cat <<EOF >$GLUSTER_ALERTS
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: gluster-alerts
  namespace: monitoring
  labels:
    app: gluster
    app-component: gluster
    prometheus: k8s
    role: alert-rules
spec:
EOF
sed 's/^/  /' $OUT_GENERATED_ROOT/gluster-mixin/prometheus_alerts.yml >>$GLUSTER_ALERTS

echo "Conert Gluster Grafana dashboard"
GRAFANA_DASHBOARD_ROOT=$OUT_CONVERTED_ROOT/monitoring-grafana.deploy/app/config/dashboards
mkdir -p $GRAFANA_DASHBOARD_ROOT
sed -e 's/^   "title": ".*",/   "title": "GlusterFS Volumes",/' \
    -e 's/^   "tags": \[ ],/   "tags": [\n     "infra",\n     "gluster"\n   ],/' \
    $OUT_GENERATED_ROOT/gluster-mixin/dashboards/k8s-storage-resources-glusterfs-pv.json \
    >$GRAFANA_DASHBOARD_ROOT/glusterfs-volumes.json
