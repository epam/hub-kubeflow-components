# Kubeflow Profiles

Kubeflow Profile CRD is designed to solve access management within multi-user kubernetes cluster.

Profile access management provides namespace level isolation based on:

* k8s rbac access control
* Istio rbac access control

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml
components:
  - name: kubeflow-profiles
    source:
      dir: components/kubeflow-profiles
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-profiles
```

To initiate the deployment, run the following commands:

  ```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy -c kubeflow-profiles
```

## Requirements

- Kubernetes
- [Kustomize](https://kustomize.io) 
- [Istio Ingress Gateway](../istio-ingressgateway)
- [Kubeflow common](../kubeflow-common)
- [Kubeflow Authn](../kubeflow-authn)

## Parameters

| Name                    | Description                                               | Default Value                                                                        | Required |
|:------------------------|:----------------------------------------------------------|:-------------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Kubernetes namespace for this component                   |                                                                                      |          |
| `kubeflow.version`      | Kubeflow version                                          | `v1.2.0`                                                                             |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                           | [kubeflow manifest](https://github.com/kubeflow/manifests/tree/master)               |          |
| `kustomize.subpath`     | Tarball archive subpath where kustomize files are located | [profiles](https://github.com/kubeflow/manifests/tree/master/apps/profiles/upstream) |          |
| `dex.passwordDb.email`  | Administrator email                                       | `bdaml`                                                                              |          |
| `hub.backup.file`       | Profiles backup file                                      |                                                                                      |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── backup                      # shell script that contains backup routines
├── hub-component.yaml          # configuration and parameters file of Hub component
├── kustomization.yaml.template # main kustomize template file
└── post-deploy                 # script that is executed after deploy of the current component
```

This component uses Kustomize extension and follows common design guidelines for Kustomize components.

## See Also

* Kubeflow Multi-user
  Isolation [getting started](https://www.kubeflow.org/docs/components/multi-tenancy/getting-started/)
