// imageName extracts the image name from a fully qualified image string. eg.
// quay.io/coreos/addon-resizer -> addon-resizer
// grafana/grafana -> grafana
local imageName(image) =
    local parts = std.split(image, '/');
    local len = std.length(parts);
    if len == 3 then
        # registry.com/org/image
        parts[2]
    else if len == 2 then
        # org/image
        parts[1]
    else if len == 1 then
        # image, ie. busybox
        parts[0]
    else
        error 'unknown image format: ' + image;

// withImageRepository is a mixin that replaces all images prefixes by repository. eg.
// quay.io/coreos/addon-resizer -> $repository/addon-resizer
// grafana/grafana -> grafana $repository/grafana
local withImageRepository(repository) = {
    local oldRepos = super._config.imageRepos,
    local substituteRepository(image, repository) =
        if repository == null then image else repository + '/' + imageName(image),
    _config+:: {
        imageRepos:: {
            [field]: substituteRepository(oldRepos[field], repository),
            for field in std.objectFields(oldRepos)
        }
    },
};

function(repository=null)
    local config = import 'config.libsonnet';
    local kp = (import 'kube-prometheus/kube-prometheus.libsonnet') + {
        _config+:: config,
    } + withImageRepository(repository);

    { ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
    { ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
    { ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
    { ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
    { ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
    { ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
    { ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
