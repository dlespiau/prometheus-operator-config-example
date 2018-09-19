# kube-prometheus example configuration

This repository holds an configuration example for kube-prometheus. It can be used to build Kubernetes manifests that will install the [Prometheus Operator](https://github.com/coreos/prometheus-operator). The jsonnet sources can be found in the [kube-prometheus contrib directory](https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus) upstream.

## Prerequisites

[jsonnet](https://jsonnet.org/) and [gojsontoyaml](https://github.com/brancz/gojsontoyaml).

## Build

```console
$ ./build.sh
```

This will create a `manifests/` directory with all resources to apply:

```console
$ kubectl -f manifests/
```

## Building manifests for an internal repository

It's possible to specify an image repository we'd like to use instead of upstream images:

```console
./build.sh --tla-str repository=foo.com/organization

```

## Mirroring public images to an internal repository

Because the image names and tags used by the prometheus operator are defined in code, I've written a bit of jsonnet outputing the docker commands necessary to mirror all images used by the operator to an internal repository:

```console
$ jsonnet -S --tla-str repository=foo.com/organization sync-to-registry.jsonnet 
docker pull quay.io/coreos/addon-resizer:1.0
docker tag quay.io/coreos/addon-resizer:1.0 foo.com/organization/addon-resizer:1.0
docker push foo.com/organization/addon-resizer:1.0
docker pull quay.io/prometheus/alertmanager:v0.15.2
docker tag quay.io/prometheus/alertmanager:v0.15.2 foo.com/organization/alertmanager:v0.15.2
docker push foo.com/organization/alertmanager:v0.15.2
docker pull quay.io/coreos/kube-rbac-proxy:v0.3.1
docker tag quay.io/coreos/kube-rbac-proxy:v0.3.1 foo.com/organization/kube-rbac-proxy:v0.3.1
docker push foo.com/organization/kube-rbac-proxy:v0.3.1
docker pull quay.io/coreos/kube-state-metrics:v1.3.1
docker tag quay.io/coreos/kube-state-metrics:v1.3.1 foo.com/organization/kube-state-metrics:v1.3.1
docker push foo.com/organization/kube-state-metrics:v1.3.1
docker pull quay.io/prometheus/node-exporter:v0.16.0
docker tag quay.io/prometheus/node-exporter:v0.16.0 foo.com/organization/node-exporter:v0.16.0
docker push foo.com/organization/node-exporter:v0.16.0
docker pull quay.io/prometheus/prometheus:v2.3.2
docker tag quay.io/prometheus/prometheus:v2.3.2 foo.com/organization/prometheus:v2.3.2
docker push foo.com/organization/prometheus:v2.3.2
docker pull quay.io/coreos/prometheus-operator:v0.23.2
docker tag quay.io/coreos/prometheus-operator:v0.23.2 foo.com/organization/prometheus-operator:v0.23.2
docker push foo.com/organization/prometheus-operator:v0.23.2
```
