# Kubeflow Volumes Web Application

This web application allows user to review and delete persistent volumes that they do not need anymore

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml
components:
  - name: kubeflow-volumes
    source:
      dir: components/kubeflow-volumes
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-volumes
```

To initiate the deployment, run the following commands:

  ```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy -c kubeflow-volumes
```

## Requirements

- [Kustomize](https://kustomize.io)
- [Kubeflow-common](../kubeflow-common)
- [Kubeflow-profiles](../kubeflow-profiles)
- [Istio-ingressgateway](../istio-ingressgateway)

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                    | Description                                               | Default Value                                                                                      | Required |
|-------------------------|-----------------------------------------------------------|----------------------------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component            | `kubeflow`                                                                                         |          |
| `kubeflow.version`      | Version of Kubeflow                                       | `v1.6.1`                                                                                           |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                           | [kubeflow manifest](https://github.com/kubeflow/manifests/tree/master)                             |          |
| `kustomize.subpath`     | Tarball archive subpath where kustomize files are located | [volumes web app](https://github.com/kubeflow/manifests/tree/master/apps/volumes-web-app/upstream) |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── kustomization.yaml                          # main kustomize file
└── hub-component.yaml                          # configuration and parameters file of Hub component
```

This component uses Kustomize extension and follows common design guidelines for Kustomize components.

## See also

