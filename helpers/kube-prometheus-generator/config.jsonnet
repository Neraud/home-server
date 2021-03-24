local kp =
  (import 'kube-prometheus/kube-prometheus.libsonnet') +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/kube-prometheus-anti-affinity.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-managed-cluster.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-node-ports.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-static-etcd.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-thanos-sidecar.libsonnet') +
  {
    _config+:: {
      namespace: 'monitoring',
      
      cpuThrottlingPercent: 33,
      cpuThrottlingSelector: 'namespace !~ "monitoring-.*(exporter|metrics)", container != "prometheus-config-reloader"',

      prometheus+:: {
        name: 'k8s',
        replicas: 1,
      },

      alertmanager+:: {
        name: 'k8s',
        replicas: 1,
      },

      grafanaK8s+:: {
        dashboardTags: ['infra', 'kubernetes'],

        // For links between grafana dashboards, you need to tell us if your grafana
        // servers under some non-root path.
        linkPrefix: '/grafana',
      },
    },

    prometheus+:: {
      prometheus+: {
        // Reference info: https://coreos.com/operators/prometheus/docs/latest/api.html#prometheusspec
        spec+: {
          nodeSelector+: {
            'capability/general-purpose': 'yes',
          },
          // An e.g. of the purpose of this is so the "Source" links on http://<alert-manager>/#/alerts are valid.
          externalUrl: 'https://infra.{{ web_base_domain }}/prometheus/',
        },
      },
    },
    
    alertmanager+:: {
      alertmanager+: {
        // Reference info: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#alertmanagerspec
        spec+: {
          nodeSelector+: {
            'capability/general-purpose': 'yes',
          },
          externalUrl: 'https://infra.{{ web_base_domain }}/alertmanager/',
          secrets: [ 'cluster-ca' ],
        },
      },
    },
  };

{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{ ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
