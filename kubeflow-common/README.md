# Kubeflow Common

The Kubeflow Common component defines primarily common Kubernetes roles for Kubeflow applications. Kubeflow is heavily
relying on aggregating roles, so it can be used from the user's profile (namespace).

Additionally, this component defines an Istio Gateway. This gateway is used to expose all Kubeflow applications.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml`file

```yaml
components:
  - name: kubeflow-common
    source:
      dir: components/kubeflow-common
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-common
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c kubeflow-common
```

## Requirements

- Kubernetes Cluster
- Istio
- Istio Ingress Gateway
- [Kustomize](https://kustomize.io/) or [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Parameters

| Name                          | Description                                                                                          |                             Default Value                             | Required |
|:------------------------------|:-----------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------:|:--------:|
| `kubernetes.namespace`        | Kubernetes namespace for this component                                                              |                              `kubeflow`                               |
| `ingress.hosts`               | Whitespace separated list of kubeflow hosts to configure Istio Gateway. Empty means `*` will be used |                                                                       |
| `istio.ingressGateway.labels` | Whitespace separated list of `key=value` labels to use as a Istio Gateway selector for the Gateway   |                                  `x`                                  |
| `kubeflow.version`            | Kubeflow version                                                                                  |                               `v1.6.1`                                |
| `kubeflow.crd`                | URL links to the metacontroller and application CRDs                                                 |                                 `URL`                                 |    x     |
| `kubeflow.tarball.url`        | URL to kubeflow manifests that correspond to the `kubeflow.version`                                  | [github](https://github.com/kubeflow/manifests/archive/v1.6.1.tar.gz) |          |
| `kubeflow.tarball.subpath`    | Location of cluster roles in the kubernetes manifests tarball                                        |            see [hub-component.yaml](./hub-component.yaml)             |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── gateway.yaml.gotemplate         # istio gateway for all kubeflow apps
├── hub-component.yaml              # parameters definitions
└── kustomization.yaml.gotemplate   # kustomize file for ths component
```

Deployment follows to the following algorithm:

1. Hubctl will download tarball and extract cluster-roles into `kustomize` directory.
2. It will also install `metacontroller` and `application` CRDs. Metacontroller is not used anymore. however some
   Kubeflow apps are still declare some of these resources.
3. Pass deployment to the `kustomize.yaml` file

## See also

- [Default Kubeflow ClusterRoles](https://github.com/kubeflow/manifests/tree/v1.2-branch/kubeflow-roles)
- [Kubernetes Application controller](https://github.com/kubernetes-sigs/application)
- [Istio Ingress Gateways](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/)
