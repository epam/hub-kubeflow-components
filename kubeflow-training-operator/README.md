# Kubeflow Training Operator

Training operator provides Kubernetes custom resources that makes it easy to run distributed or
non-distributed TensorFlow/PyTorch/Apache MXNet/XGBoost/MPI jobs on Kubernetes.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml
components:  
  - name: kubeflow-training-operator
    source:
      dir: components/kubeflow-training-operator
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-training-operator
```

To initiate the deployment, run the following commands:

  ```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy -c kubeflow-training-operator
```

## Requirements

- Kubernetes
- [Kustomize](https://kustomize.io) 
- [Kubeflow-common](../kubeflow-common)

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                    | Description                                               | Default Value                                                                                          | Required |
|-------------------------|-----------------------------------------------------------|--------------------------------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component            | `kubeflow`                                                                                             |          |
| `kubeflow.version`      | Version of Kubeflow                                       | `v1.5.1`                                                                                               |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                           | [kubeflow manifest](https://github.com/kubeflow/manifests/tree/master)                                 |          |
| `kustomize.subpath`     | Tarball archive subpath where kustomize files are located | [training operator](https://github.com/kubeflow/manifests/tree/master/apps/training-operator/upstream) |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── kustomization.yaml                          # main kustomize file
└── hub-component.yaml                          # configuration and parameters file of Hub component
```

This component uses Kustomize extension and follows common design guidelines for Kustomize components.

## See Also

* Kubeflow training operator [github](https://github.com/kubeflow/training-operator)
