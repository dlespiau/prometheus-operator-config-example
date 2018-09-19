function(repository='upstream')
    local withRepository(repository) = if repository != 'upstream' then {
        _config+:: {
            imageRepos+:: {
                prometheus: repository + "/prometheus",
                alertmanager: repository + "/alertmanager",
                kubeStateMetrics: repository + "/kube-state-metrics",
                kubeRbacProxy: repository + "/kube-rbac-proxy",
                addonResizer: repository + "/addon-resizer",
                nodeExporter: repository + "/node-exporter",
                prometheusOperator: repository + "/prometheus-operator",
            },
        },
    } else {};

    local config = import 'config.libsonnet';
    local kp = (import 'kube-prometheus/kube-prometheus.libsonnet') + {
        _config+:: config,
    } + withRepository(repository);

    { ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
    { ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
    { ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
    { ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
    { ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
    { ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
    { ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
