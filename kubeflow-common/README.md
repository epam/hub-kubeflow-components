# Kubeflow Common

The Kubeflow Common could refer to the shared concepts and practices that are part of the Kubeflow ecosystem to streamline and standardize machine learning workflows on Kubernetes. This component perform 3 operations.

## TLDR
```yaml
  - name: kubeflow-common
    source:
      dir: components/kubeflow-common
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-common
```

## Requirements

- Helm
- Kubernetes
- Kustomize

## Parameters

| Name                   | Description                                    | Default Value                                                              | Required |
|------------------------|------------------------------------------------|----------------------------------------------------------------------------|:--------:|
| `ingress.hosts`        | Hostname of the kubeflow stack                 |                                                                            |          |
| `istio.namespace`      | Kubernetes namespace for Istio                 |                                                                            |          |
| `istio.ingressGateway` | Name of Istio ingress gateway service          |                                                                            |          |
| `kubeflow.namespace`   | Target Kubernetes namespace for this component |                                                                            |          |
| `kubeflow.version`     | Version of Kubeflow                            | `v1.2.0`                                                                   |          |
| `kubeflow.tarball`     | URL to kubeflow tarball archive                | `https://github.com/kubeflow/manifests/archive/${kubeflow.version}.tar.gz` |          |

## Implementation Details

The component has the following directory structure:
```text
./
├── gateway.yaml.gotemplate         # Istio gateway definition template
├── hub-component.yaml              # Parameters definitions
└── kustomization.yaml.template     # Kustomize file for ths component
```

Deployment follows to the following algorithm:
1. Creates istio gateway custom resource from `gateway.yaml.gotemplate`.
2. [Application](https://github.com/kubernetes-sigs/application) that aggregates all kubeflow applications.
3. Then start deployment

## See also

- [Default Kubeflow ClusterRoles](https://github.com/kubeflow/manifests/tree/v1.2-branch/kubeflow-roles)
- [Kubernetes Application controller](https://github.com/kubernetes-sigs/application)
- [Istio Ingress Gateways](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/)
