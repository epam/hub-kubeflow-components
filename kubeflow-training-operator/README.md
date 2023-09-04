# Kubeflow Training Operator

Training operator provides Kubernetes custom resources that makes it easy to run distributed or
non-distributed TensorFlow/PyTorch/Apache MXNet/XGBoost/MPI jobs on Kubernetes.

## TL;DR

Declare hubctl stack with

```shell
cat << EOF > hub.yaml
version: 1
kind: stack

requires:
  - kubernetes
  
components:  
  - name: kubeflow-training-operator
    source:
      dir: components/kubeflow-training-operator
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-training-operator
    depends:
      - kubeflow-common  
EOF

hubctl stack init
hubctl stack deploy
```

## Requirements

- Kubernetes
- [kustomize](https://kustomize.io) CLI.
- [kubeflow-common](/kubeflow-common)

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                    | Description                                    | Default Value                                                               | Required 
|-------------------------|------------------------------------------------|-----------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component | `kubeflow`                                                                  |          |
| `kubeflow.version`      | Version of Kubeflow                            | `v1.5.1`                                                                    |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                | `https://codeload.github.com/kubeflow/manifests/tar.gz/${kubeflow.version}` |          |
| `kustomize.subpath`     | Directories from kubeflow tarball archive      |                                                                             |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── kustomization.yaml                          # Main kustomize file
├── README.md                                   
└── hub-component.yaml                          # Configuration and parameters file of Hub component
```
This component uses Kustomize extension and follows common design guidelines for Kustomize components.

## See Also

* Kubeflow training operator [github](https://github.com/kubeflow/training-operator)
