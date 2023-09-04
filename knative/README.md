# Knative Eventing

Knative is a Kubernetes-based platform that helps manage serverless workloads. It provides a set of building blocks and abstractions that simplify the development and operations of serverless workloads, making it easier to build event-driven, auto-scaling, and portable applications.

## TLDR

```yaml
  - name: knative
    source:
      dir: components/knative
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: knative
```

## Requirements

- Helm
- Kubernetes
- Kustomize

## Parameters

| Name                   | Description                                                      | Default Value     | Required |
|------------------------|------------------------------------------------------------------|-------------------|:--------:|
| `kubernetes.version`   | Version of kustomize serving                                     | `v1.5.0`          |          |
| `kubernetes.namespace` | Kubernetes namespace                                             | `knative` |          |
| `kustomize.crd`        | Version specific CRD to download CRDs                            | `URL`             |          |
| `kustomize.resources`  | Kubernetes resources to be downloaded to `./kustomize` directory | `URL`             |          |

## Implementation Details

The component has the following directory structure:
```text
./
├── hub-component.yaml                    # Component definition
└── kustomization.yaml.template           # Template for kustomize file that will drive the deployment
```

Deployment follows to the following algorithm:

1. At the beginning of deployment hubctl will read `kustomize.resources` parameter to download resources from URLs (whitespace separated) to the `./kustomize` directory. So, it would be accessible for `kustomization.yaml` file.
2. Then start deployment

## See Also

- [knative](https://knative.dev/)
- [Knative Eventing](https://knative.dev/docs/install/yaml-install/eventing/install-eventing-with-yaml)
- Description tables for [Installatin Files](https://knative.dev/docs/install/yaml-install/eventing/eventing-installation-files/)
