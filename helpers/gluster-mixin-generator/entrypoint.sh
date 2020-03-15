#!/usr/bin/env sh

echo "Gluster mixin"

mkdir -p /opt/gluster-mixins
cd /opt/gluster-mixins

echo " - create custom configuration"
cat <<EOF >mixin.libsonnet
local gluster = import "gluster-mixins/mixin.libsonnet";

gluster {
  _config+:: {
    // Selectors are inserted between {} in Prometheus queries.
    glusterExporterSelector: 'job="gluster-exporter"',

    // For links between grafana dashboards, you need to tell us if your grafana
    // servers under some non-root path.
    grafanaPrefix: '/grafana',
  },
}
EOF

echo " - installing requirements ..."
jb init
jb install github.com/gluster/gluster-mixins

mkdir -p /out/gluster-mixin/dashboards
echo " - generating prometheus_alerts ..."
jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusAlerts)' >/out/gluster-mixin/prometheus_alerts.yml
echo " - generating prometheus_rules ..."
jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusRules)' >/out/gluster-mixin/prometheus_rules.yml
echo " - generating dashboards_out ..."
jsonnet -J vendor -m /out/gluster-mixin/dashboards -e '(import "mixin.libsonnet").grafanaDashboards'

chmod -R 777 /out
