#!/usr/bin/env sh

OUT_GENERATED_ROOT=$(pwd)/out
OUT_CONVERTED_ROOT=$(pwd)/out/converted
OUT_GENERATED_GLUSTER_MIXIN_ROOT=${OUT_GENERATED_ROOT}/gluster-mixin

if [ -d $OUT_CONVERTED_ROOT ]; then
  rm -R $OUT_CONVERTED_ROOT
fi

echo "Convert PrometheusRules"

GLUSTER_MIXIN_PROMEHTEUS_RULES_ROOT=$OUT_CONVERTED_ROOT/monitoring_prometheus_operator_deploy/app/config/prometheus/rules/gluster-mixin
mkdir -p $GLUSTER_MIXIN_PROMEHTEUS_RULES_ROOT
python3 extract_rules.py $OUT_GENERATED_GLUSTER_MIXIN_ROOT/prometheus_rules.yml $GLUSTER_MIXIN_PROMEHTEUS_RULES_ROOT
python3 extract_rules.py $OUT_GENERATED_GLUSTER_MIXIN_ROOT/prometheus_alerts.yml $GLUSTER_MIXIN_PROMEHTEUS_RULES_ROOT

echo "Convert Gluster Grafana dashboard"
GLUSTER_MIXIN_GRAFANA_DASHBOARD_ROOT=$OUT_CONVERTED_ROOT/monitoring_grafana_deploy/app/config/dashboards/gluster-mixin
mkdir -p $GLUSTER_MIXIN_GRAFANA_DASHBOARD_ROOT
for file in $OUT_GENERATED_GLUSTER_MIXIN_ROOT/dashboards/*.json; do
  echo " - processing $file"
  python3 clean_dashboard.py $file $GLUSTER_MIXIN_GRAFANA_DASHBOARD_ROOT/$(basename $file)
done
