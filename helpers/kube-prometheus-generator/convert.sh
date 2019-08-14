#!/usr/bin/env sh

OUT_GENERATED_ROOT=$(pwd)/out
OUT_CONVERTED_ROOT=$(pwd)/out/converted

if [ -d $OUT_CONVERTED_ROOT ]; then
  rm -R $OUT_CONVERTED_ROOT
fi

echo "Converting Operator"
OPERATOR_ROOT=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/operator
mkdir -p $OPERATOR_ROOT
cp $OUT_GENERATED_ROOT/0prometheus-operator-0alertmanagerCustomResourceDefinition.yaml $OPERATOR_ROOT/alertmanagerCustomResourceDefinition.yaml
cp $OUT_GENERATED_ROOT/0prometheus-operator-0podmonitorCustomResourceDefinition.yaml $OPERATOR_ROOT/podmonitorCustomResourceDefinition.yaml
cp $OUT_GENERATED_ROOT/0prometheus-operator-0prometheusCustomResourceDefinition.yaml $OPERATOR_ROOT/prometheusCustomResourceDefinition.yaml
cp $OUT_GENERATED_ROOT/0prometheus-operator-0prometheusruleCustomResourceDefinition.yaml $OPERATOR_ROOT/prometheusruleCustomResourceDefinition.yaml
cp $OUT_GENERATED_ROOT/0prometheus-operator-0servicemonitorCustomResourceDefinition.yaml $OPERATOR_ROOT/servicemonitorCustomResourceDefinition.yaml
cp $OUT_GENERATED_ROOT/0prometheus-operator-clusterRoleBinding.yaml $OPERATOR_ROOT/clusterRoleBinding.yaml
cp $OUT_GENERATED_ROOT/0prometheus-operator-clusterRole.yaml $OPERATOR_ROOT/clusterRole.yaml
cp $OUT_GENERATED_ROOT/0prometheus-operator-deployment.yaml $OPERATOR_ROOT/deployment.yaml.j2
cp $OUT_GENERATED_ROOT/0prometheus-operator-serviceAccount.yaml $OPERATOR_ROOT/serviceAccount.yaml
cp $OUT_GENERATED_ROOT/0prometheus-operator-service.yaml $OPERATOR_ROOT/service.yaml

echo "Converting AlertManager"
ALERTMANAGER_ROOT=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/alertmanager
mkdir -p $ALERTMANAGER_ROOT
cp $OUT_GENERATED_ROOT/alertmanager-alertmanager.yaml $ALERTMANAGER_ROOT/alertmanager.yaml.j2
cp $OUT_GENERATED_ROOT/alertmanager-secret.yaml $ALERTMANAGER_ROOT/secret.yaml.j2
cp $OUT_GENERATED_ROOT/alertmanager-serviceAccount.yaml $ALERTMANAGER_ROOT/serviceAccount.yaml
cp $OUT_GENERATED_ROOT/alertmanager-service.yaml $ALERTMANAGER_ROOT/service.yaml

echo "Converting Grafana"
GRAFANA_ROOT=$OUT_CONVERTED_ROOT/monitoring-grafana.deploy/app/deploy
mkdir -p $GRAFANA_ROOT
cp $OUT_GENERATED_ROOT/grafana-dashboardDatasources.yaml $GRAFANA_ROOT/datasources-secret.yaml.j2
cp $OUT_GENERATED_ROOT/grafana-dashboardDefinitions.yaml $GRAFANA_ROOT/dashboardProviders-configMap.yaml
cp $OUT_GENERATED_ROOT/grafana-dashboardSources.yaml $GRAFANA_ROOT/dashboards-configMap.yaml.j2
cp $OUT_GENERATED_ROOT/grafana-deployment.yaml $GRAFANA_ROOT/statefulSet.yaml.j2
cp $OUT_GENERATED_ROOT/grafana-serviceAccount.yaml $GRAFANA_ROOT/serviceAccount.yaml
cp $OUT_GENERATED_ROOT/grafana-service.yaml $GRAFANA_ROOT/service.yaml

echo "Converting Kube state metrics"
KUBE_STATE_METRICS_ROOT=$OUT_CONVERTED_ROOT/monitoring-exporters.deploy/app/deploy/kube-state-metrics
mkdir -p $KUBE_STATE_METRICS_ROOT
cp $OUT_GENERATED_ROOT/kube-state-metrics-clusterRoleBinding.yaml $KUBE_STATE_METRICS_ROOT/kube-state-metrics-clusterRoleBinding.yaml
cp $OUT_GENERATED_ROOT/kube-state-metrics-clusterRole.yaml $KUBE_STATE_METRICS_ROOT/kube-state-metrics-clusterRole.yaml
cp $OUT_GENERATED_ROOT/kube-state-metrics-deployment.yaml $KUBE_STATE_METRICS_ROOT/kube-state-metrics-deployment.yaml.j2
cp $OUT_GENERATED_ROOT/kube-state-metrics-roleBinding.yaml $KUBE_STATE_METRICS_ROOT/kube-state-metrics-roleBinding.yaml
cp $OUT_GENERATED_ROOT/kube-state-metrics-role.yaml $KUBE_STATE_METRICS_ROOT/kube-state-metrics-role.yaml
cp $OUT_GENERATED_ROOT/kube-state-metrics-serviceAccount.yaml $KUBE_STATE_METRICS_ROOT/kube-state-metrics-serviceAccount.yaml
cp $OUT_GENERATED_ROOT/kube-state-metrics-service.yaml $KUBE_STATE_METRICS_ROOT/kube-state-metrics-service.yaml

echo "Converting NodeExporter"
NODE_EXPORTER_ROOT=$OUT_CONVERTED_ROOT/monitoring-exporters.deploy/app/deploy/node-exporter
mkdir -p $NODE_EXPORTER_ROOT
cp $OUT_GENERATED_ROOT/node-exporter-clusterRoleBinding.yaml $NODE_EXPORTER_ROOT/node-exporter-clusterRoleBinding.yaml
cp $OUT_GENERATED_ROOT/node-exporter-clusterRole.yaml $NODE_EXPORTER_ROOT/node-exporter-clusterRole.yaml
cp $OUT_GENERATED_ROOT/node-exporter-daemonset.yaml $NODE_EXPORTER_ROOT/node-exporter-daemonset.yaml.j2
cp $OUT_GENERATED_ROOT/node-exporter-serviceAccount.yaml $NODE_EXPORTER_ROOT/node-exporter-serviceAccount.yaml
cp $OUT_GENERATED_ROOT/node-exporter-service.yaml $NODE_EXPORTER_ROOT/node-exporter-service.yaml

echo "Converting Prometheus"
PROMETHEUS_ROOT=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/prometheus
mkdir -p $PROMETHEUS_ROOT
cp $OUT_GENERATED_ROOT/prometheus-clusterRoleBinding.yaml $PROMETHEUS_ROOT/clusterRoleBinding.yaml
cp $OUT_GENERATED_ROOT/prometheus-clusterRole.yaml $PROMETHEUS_ROOT/clusterRole.yaml
cp $OUT_GENERATED_ROOT/prometheus-prometheus.yaml $PROMETHEUS_ROOT/prometheus.yaml.j2
cp $OUT_GENERATED_ROOT/prometheus-roleBindingConfig.yaml $PROMETHEUS_ROOT/roleBindingConfig.yaml
cp $OUT_GENERATED_ROOT/prometheus-roleBindingSpecificNamespaces.yaml $PROMETHEUS_ROOT/roleBindingSpecificNamespaces.yaml.j2
cp $OUT_GENERATED_ROOT/prometheus-roleConfig.yaml $PROMETHEUS_ROOT/roleConfig.yaml
cp $OUT_GENERATED_ROOT/prometheus-roleSpecificNamespaces.yaml $PROMETHEUS_ROOT/roleSpecificNamespaces.yaml.j2
cp $OUT_GENERATED_ROOT/prometheus-serviceAccount.yaml $PROMETHEUS_ROOT/serviceAccount.yaml
cp $OUT_GENERATED_ROOT/prometheus-service.yaml $PROMETHEUS_ROOT/service.yaml

echo "Converting ServiceMonitors"
SERVICE_MONITOR_ROOT=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/service-monitors
mkdir -p $SERVICE_MONITOR_ROOT
cp $OUT_GENERATED_ROOT/node-exporter-serviceMonitor.yaml $SERVICE_MONITOR_ROOT/node-exporter.yaml.j2
cp $OUT_GENERATED_ROOT/kube-state-metrics-serviceMonitor.yaml $SERVICE_MONITOR_ROOT/kube-state-metrics.yaml.j2
cp $OUT_GENERATED_ROOT/grafana-serviceMonitor.yaml $SERVICE_MONITOR_ROOT/grafana.yaml.j2
cp $OUT_GENERATED_ROOT/alertmanager-serviceMonitor.yaml $SERVICE_MONITOR_ROOT/alertmanager.yaml.j2
cp $OUT_GENERATED_ROOT/0prometheus-operator-serviceMonitor.yaml $SERVICE_MONITOR_ROOT/prometheus-operator.yaml.j2
cp $OUT_GENERATED_ROOT/prometheus-serviceMonitorApiserver.yaml $SERVICE_MONITOR_ROOT/apiserver.yaml.j2
cp $OUT_GENERATED_ROOT/prometheus-serviceMonitorCoreDNS.yaml $SERVICE_MONITOR_ROOT/coreDNS.yaml.j2
cp $OUT_GENERATED_ROOT/prometheus-serviceMonitorKubeControllerManager.yaml $SERVICE_MONITOR_ROOT/kubeControllerManager.yaml.j2
cp $OUT_GENERATED_ROOT/prometheus-serviceMonitorKubelet.yaml $SERVICE_MONITOR_ROOT/kubelet.yaml.j2
cp $OUT_GENERATED_ROOT/prometheus-serviceMonitorKubeScheduler.yaml $SERVICE_MONITOR_ROOT/kubeScheduler.yaml.j2
cp $OUT_GENERATED_ROOT/prometheus-serviceMonitor.yaml $SERVICE_MONITOR_ROOT/prometheus.yaml.j2
