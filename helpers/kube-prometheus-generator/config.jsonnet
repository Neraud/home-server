local kp =
  (import 'kube-prometheus/main.libsonnet') +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/addons/anti-affinity.libsonnet') +
  // (import 'kube-prometheus/addons/managed-cluster.libsonnet') +
  // (import 'kube-prometheus/addons/node-ports.libsonnet') +
  // (import 'kube-prometheus/addons/static-etcd.libsonnet') +
  // (import 'kube-prometheus/addons/custom-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/external-metrics.libsonnet') +
  {
    values+:: {
      common+: {
        namespace: 'monitoring',
      },

      common_mixin: {
        _config+:: {
          grafanaK8s+:: {
            dashboardTags: ['infra', 'kubernetes'],

            // For links between grafana dashboards, you need to tell us if your grafana
            // servers under some non-root path.
            linkPrefix: '/grafana',
          },
        },
      },

      prometheus+:: {
        name: 'k8s',
        replicas: 1,
        mixin+: $.values.common_mixin,
      },

      alertmanager+:: {
        name: 'k8s',
        replicas: 1,
        mixin+: $.values.common_mixin,
      },

      kubeStateMetrics+:: {
        mixin+: $.values.common_mixin,
      },

      nodeExporter+:: {
        mixin+: $.values.common_mixin,
      },

      prometheusOperator+:: {
        mixin+: $.values.common_mixin,
      },

      kubernetesControlPlane+:: {
        mixin+: $.values.common_mixin + {
          _config+:: {
            cpuThrottlingPercent: 33,
            cpuThrottlingSelector: 'namespace !~ "monitoring-.*(exporter|metrics)", container != "prometheus-config-reloader"',
          },
        },
      },
      
      kubePrometheus+:: {
        mixin+: $.values.common_mixin,
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
  

{ 'setup/0namespace-namespace': kp.kubePrometheus.namespace } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor' && name != 'prometheusRule'), std.objectFields(kp.prometheusOperator))
} +
// serviceMonitor and prometheusRule are separated so that they can be created after the CRDs are ready
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ 'prometheus-operator-prometheusRule': kp.prometheusOperator.prometheusRule } +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
//{ ['blackbox-exporter-' + name]: kp.blackboxExporter[name] for name in std.objectFields(kp.blackboxExporter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) }
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
//{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
{}