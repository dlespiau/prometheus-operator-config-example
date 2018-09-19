{
    namespace: 'monitoring',
    versions+:: {
      alertmanager: "v0.15.2",
      nodeExporter: "v0.16.0",
      kubeStateMetrics: "v1.3.1",
      kubeRbacProxy: "v0.3.1",
      addonResizer: "1.0",
      prometheusOperator: "v0.23.2",
      prometheus: "v2.3.2",
    },
    imageRepos+:: {
        prometheus: "quay.io/prometheus/prometheus",
        alertmanager: "quay.io/prometheus/alertmanager",
        kubeStateMetrics: "quay.io/coreos/kube-state-metrics",
        kubeRbacProxy: "quay.io/coreos/kube-rbac-proxy",
        addonResizer: "quay.io/coreos/addon-resizer",
        nodeExporter: "quay.io/prometheus/node-exporter",
        prometheusOperator: "quay.io/coreos/prometheus-operator",
    },
}
