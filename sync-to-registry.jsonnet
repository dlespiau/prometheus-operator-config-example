local kp = import 'kube-prometheus/kube-prometheus.libsonnet';
local config = kp._config;

// imageName extracts the image name from a fully qualified image string. eg.
// quay.io/coreos/addon-resizer -> addon-resizer
// grafana/grafana:5.2.1 -> grafana
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

local makeImages(config) = [
    {
        name: config.imageRepos[image],
        tag: config.versions[image],
    }
    for image in std.objectFields(config.imageRepos)
];

local upstreamImage(image) = '%s:%s' % [image.name, image.tag];
local downstreamImage(registry, image) = '%s/%s:%s' % [registry, imageName(image.name), image.tag];

local pullPush(image, newRegistry) = [
    'docker pull %s' % upstreamImage(image),
    'docker tag %s %s' % [upstreamImage(image), downstreamImage(newRegistry, image)],
    'docker push %s' % downstreamImage(newRegistry, image),
];

local images = makeImages(config);

local output(repository) = std.flattenArrays([
  pullPush(image, repository)
  for image in images
]);

function(repository="my-registry.com/repository")
    std.join('\n', output(repository))
