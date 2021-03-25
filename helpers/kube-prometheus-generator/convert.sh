#!/usr/bin/env sh

OUT_GENERATED_ROOT=$(pwd)/out
OUT_CONVERTED_ROOT=$(pwd)/out/converted
OUT_GENERATED_KUBE_PROMETHEUS_ROOT=${OUT_GENERATED_ROOT}/kube-prometheus

if [ -d $OUT_CONVERTED_ROOT ]; then
  rm -R $OUT_CONVERTED_ROOT
fi

echo "Converting Operator"
OPERATOR_ROOT=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/operator
mkdir -p $OPERATOR_ROOT
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-0alertmanagerConfigCustomResourceDefinition.yaml $OPERATOR_ROOT/alertmanagerConfigCustomResourceDefinition.yaml
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-0alertmanagerCustomResourceDefinition.yaml $OPERATOR_ROOT/alertmanagerCustomResourceDefinition.yaml
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-0podmonitorCustomResourceDefinition.yaml $OPERATOR_ROOT/podmonitorCustomResourceDefinition.yaml
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-0probeCustomResourceDefinition.yaml $OPERATOR_ROOT/probeCustomResourceDefinition.yaml
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-0prometheusCustomResourceDefinition.yaml $OPERATOR_ROOT/prometheusCustomResourceDefinition.yaml
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-0prometheusruleCustomResourceDefinition.yaml $OPERATOR_ROOT/prometheusruleCustomResourceDefinition.yaml
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-0servicemonitorCustomResourceDefinition.yaml $OPERATOR_ROOT/servicemonitorCustomResourceDefinition.yaml
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-0thanosrulerCustomResourceDefinition.yaml $OPERATOR_ROOT/thanosrulerCustomResourceDefinition.yaml
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-clusterRoleBinding.yaml $OPERATOR_ROOT/clusterRoleBinding.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-clusterRole.yaml $OPERATOR_ROOT/clusterRole.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-deployment.yaml $OPERATOR_ROOT/deployment.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-serviceAccount.yaml $OPERATOR_ROOT/serviceAccount.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/setup/prometheus-operator-service.yaml $OPERATOR_ROOT/service.yaml.j2

echo "Converting AlertManager"
ALERTMANAGER_ROOT=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/alertmanager
mkdir -p $ALERTMANAGER_ROOT
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/alertmanager-alertmanager.yaml $ALERTMANAGER_ROOT/alertmanager.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/alertmanager-secret.yaml $ALERTMANAGER_ROOT/secret.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/alertmanager-serviceAccount.yaml $ALERTMANAGER_ROOT/serviceAccount.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/alertmanager-service.yaml $ALERTMANAGER_ROOT/service.yaml.j2

echo "Converting Grafana"
GRAFANA_ROOT=$OUT_CONVERTED_ROOT/monitoring-grafana.deploy/app/deploy
GRAFANA_DASHBOARDS_ROOT=$OUT_CONVERTED_ROOT/monitoring-grafana.deploy/app/config/dashboards/kube-prometheus
mkdir -p $GRAFANA_ROOT
mkdir -p $GRAFANA_DASHBOARDS_ROOT
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/grafana-dashboardDatasources.yaml $GRAFANA_ROOT/datasources-secret.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/grafana-dashboardDefinitions.yaml $GRAFANA_ROOT/dashboardProviders-configMap.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/grafana-dashboardSources.yaml $GRAFANA_ROOT/dashboards-configMap.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/grafana-deployment.yaml $GRAFANA_ROOT/statefulSet.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/grafana-serviceAccount.yaml $GRAFANA_ROOT/serviceAccount.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/grafana-service.yaml $GRAFANA_ROOT/service.yaml.j2
echo "Extract dashboards"
python3 extract_dashboards.py $GRAFANA_ROOT/dashboardProviders-configMap.yaml.j2 $GRAFANA_DASHBOARDS_ROOT

echo "Converting Kube state metrics"
KUBE_STATE_METRICS_ROOT=$OUT_CONVERTED_ROOT/monitoring-kube-state-metrics.deploy/app/deploy
mkdir -p $KUBE_STATE_METRICS_ROOT
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kube-state-metrics-clusterRoleBinding.yaml $KUBE_STATE_METRICS_ROOT/clusterRoleBinding.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kube-state-metrics-clusterRole.yaml $KUBE_STATE_METRICS_ROOT/clusterRole.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kube-state-metrics-deployment.yaml $KUBE_STATE_METRICS_ROOT/deployment.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kube-state-metrics-serviceAccount.yaml $KUBE_STATE_METRICS_ROOT/serviceAccount.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kube-state-metrics-service.yaml $KUBE_STATE_METRICS_ROOT/service.yaml.j2

echo "Converting NodeExporter"
NODE_EXPORTER_ROOT=$OUT_CONVERTED_ROOT/monitoring-node-exporter.deploy/app/deploy
mkdir -p $NODE_EXPORTER_ROOT
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/node-exporter-clusterRoleBinding.yaml $NODE_EXPORTER_ROOT/clusterRoleBinding.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/node-exporter-clusterRole.yaml $NODE_EXPORTER_ROOT/clusterRole.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/node-exporter-daemonset.yaml $NODE_EXPORTER_ROOT/daemonSet.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/node-exporter-serviceAccount.yaml $NODE_EXPORTER_ROOT/serviceAccount.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/node-exporter-service.yaml $NODE_EXPORTER_ROOT/service.yaml.j2

echo "Converting Prometheus"
PROMETHEUS_ROOT=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/prometheus
mkdir -p $PROMETHEUS_ROOT
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/prometheus-clusterRoleBinding.yaml $PROMETHEUS_ROOT/clusterRoleBinding.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/prometheus-clusterRole.yaml $PROMETHEUS_ROOT/clusterRole.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/prometheus-prometheus.yaml $PROMETHEUS_ROOT/prometheus.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/prometheus-roleBindingConfig.yaml $PROMETHEUS_ROOT/roleBindingConfig.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/prometheus-roleConfig.yaml $PROMETHEUS_ROOT/roleConfig.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/prometheus-serviceAccount.yaml $PROMETHEUS_ROOT/serviceAccount.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/prometheus-service.yaml $PROMETHEUS_ROOT/service.yaml.j2
# Not really the same file, but the role inside should sort of match
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/prometheus-roleSpecificNamespaces.yaml $PROMETHEUS_ROOT/clusterRole-allNamespaces.yaml.j2

echo "Converting ServiceMonitors"
SERVICE_MONITOR_ROOT=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/service-monitors
mkdir -p $SERVICE_MONITOR_ROOT
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/node-exporter-serviceMonitor.yaml $SERVICE_MONITOR_ROOT/node-exporter.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kube-state-metrics-serviceMonitor.yaml $SERVICE_MONITOR_ROOT/kube-state-metrics.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/grafana-serviceMonitor.yaml $SERVICE_MONITOR_ROOT/grafana.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/alertmanager-serviceMonitor.yaml $SERVICE_MONITOR_ROOT/alertmanager.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/prometheus-operator-serviceMonitor.yaml $SERVICE_MONITOR_ROOT/prometheus-operator.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kubernetes-serviceMonitorApiserver.yaml $SERVICE_MONITOR_ROOT/apiserver.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kubernetes-serviceMonitorCoreDNS.yaml $SERVICE_MONITOR_ROOT/coreDNS.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kubernetes-serviceMonitorKubeControllerManager.yaml $SERVICE_MONITOR_ROOT/kubeControllerManager.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kubernetes-serviceMonitorKubelet.yaml $SERVICE_MONITOR_ROOT/kubelet.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kubernetes-serviceMonitorKubeScheduler.yaml $SERVICE_MONITOR_ROOT/kubeScheduler.yaml.j2
cp $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/prometheus-serviceMonitor.yaml $SERVICE_MONITOR_ROOT/prometheus.yaml.j2

echo "Convert PrometheusRules"
PROMEHTEUS_RULES_ROOT=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/config/prometheus/rules/kube-prometheus
mkdir -p $PROMEHTEUS_RULES_ROOT
python3 extract_rules.py $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/alertmanager-prometheusRule.yaml $PROMEHTEUS_RULES_ROOT
python3 extract_rules.py $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kube-prometheus-prometheusRule.yaml $PROMEHTEUS_RULES_ROOT
python3 extract_rules.py $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kube-state-metrics-prometheusRule.yaml $PROMEHTEUS_RULES_ROOT
python3 extract_rules.py $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/kubernetes-prometheusRule.yaml $PROMEHTEUS_RULES_ROOT
python3 extract_rules.py $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/node-exporter-prometheusRule.yaml $PROMEHTEUS_RULES_ROOT
python3 extract_rules.py $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/prometheus-operator-prometheusRule.yaml $PROMEHTEUS_RULES_ROOT
python3 extract_rules.py $OUT_GENERATED_KUBE_PROMETHEUS_ROOT/prometheus-prometheusRule.yaml $PROMEHTEUS_RULES_ROOT
