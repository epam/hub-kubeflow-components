# Kubeflow Common

## Overview of the Kubeflow Common

This component perform 3 operations.

### Default Kubeflow ClusterRoles

This [manifest package](https://github.com/kubeflow/manifests/tree/v1.2-branch/kubeflow-roles) contains the default ClusterRoles Kubeflow uses for defining roles for Kubeflow user Profiles.
These roles are currently assigned to users by Profiles (profile-controller and kfam) Service with the help of Manage Users page in Central Dashboard.

### Istio Gateway Custom Resource

Creates istio gateway custom resource from `gateway.yaml.template`.

### Application controller

[Application](https://github.com/kubernetes-sigs/application) that aggregates all kubeflow applications.

## Implementation Details

The component has the following directory structure:

```text
./
├── crds                        # Directory contains kubernetes CRDs manifests
├── gateway.yaml.template       # Istio gateway definition template
├── hub-component.yaml          # Parameters definitions
├── kustomization.yaml.template # Kustomize file for ths component
├── pre-deploy                  # Script to download tarball from kubeflow distribution website
└── pre-undeploy -> pre-deploy
```

The component uses an offical Kubeflow distribution Kustomize [scripts]("https://github.com/kubeflow/manifests/") as a and applies patches and additiona resources described in [kustomize.yaml](kustomize.yaml.template) file.

Where [pre-deploy](pre-deploy) script has been responsible for download tarball from Kubeflow official distribution website.

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name      | Description | Default Value
| --------- | ---------   | ---------
| `dns.domain` | Domain name of the kubeflow stack | |
| `component.ingress.protocol` | HTTP or HTTPS schema | |
| `component.istio.namespace` | Kubernetes namespace for Istio | |
| `component.istio.ingressGateway` | Name of Istio ingress gateway service | |
| `component.kubeflow.name` | Target Kubernetes resources name for this component | |
| `component.kubeflow.namespace` | Target Kubernetes namespace for this component | |
| `component.kubeflow.version` | Version of Kubeflow | `v1.2.0` |
| `component.kubeflow.tarball` | URL to kubeflow tarball archive | `https://github.com/kubeflow/manifests/archive/${component.kubeflow.version}.tar.gz` |

## See also

- [Default Kubeflow ClusterRoles](https://github.com/kubeflow/manifests/tree/v1.2-branch/kubeflow-roles)
- [Kubernetes Application controller](https://github.com/kubernetes-sigs/application)
- [Istio Ingress Gateways](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/)
