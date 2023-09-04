# TensorFlow Training

TFJob is a Kubernetes custom resource to run [TensorFlow training](https://www.kubeflow.org/docs/components/training/tftraining/) jobs on Kubernetes. The Kubeflow implementation of TFJob is in training-operator.

## TL;DR

Declare hubctl stack with

```shell
cat << EOF > hub.yaml
version: 1
kind: stack

requires:
  - kubernetes
  
components:  
  - name: kubeflow-tf-training
    source:
      dir: components/kubeflow-tf-training
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-tf-training
EOF

hubctl stack init
hubctl stack deploy
```

## Requirements

- Kubernetes
- [kustomize](https://kustomize.io) CLI.

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name                    | Description                                    | Default Value                                                               | Required 
|-------------------------|------------------------------------------------|-----------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component | `kubeflow`                                                                  |          |
| `kubeflow.name`         | Name of Kubeflow component                     |                                                                    |          |
| `kubeflow.version`      | Version of Kubeflow                            | `v1.2.0`                                                                    |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                | `https://codeload.github.com/kubeflow/manifests/tar.gz/${kubeflow.version}` |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── crds                              # Directory contains custom resource definition files
│   └── tfjobs.yaml                   # CRD of TFJob kind
├── hub-component.yaml                # Configuration and parameters file of Hub component
├── kustomization.yaml.template       # Main kustomize template file
├── pre-deploy                        # Script to download tarball from kubeflow distribution website
└── pre-undeploy -> pre-deploy        # simlink to support undeploy
```

## See also

- TensorFlow training [overview](https://www.kubeflow.org/docs/components/training/tftraining/)
- [TensorFlow](https://www.tensorflow.org/)
