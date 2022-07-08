# TensorFlow Training

## Overview of the TensorFlow Training

TFJob is a Kubernetes custom resource to run [TensorFlow training](https://www.kubeflow.org/docs/components/training/tftraining/) jobs on Kubernetes. The Kubeflow implementation of TFJob is in training-operator.

## Implementation Details

The component has the following directory structure:

```text
./
├── crds                                  # Directory contains custom resource definition files
│   └── tfjobs.yaml                       # CRD of TFJob kind
├── hub-component.yaml                    # Parameters definitions
├── kustomization.yaml.template           # Kustomize file for ths component
├── pre-deploy                            # Script to download tarball from kubeflow distribution website
└── pre-undeploy                          # Script to download tarball from kubeflow distribution website
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `dns.domain` | Domain name of the kubeflow stack | |
| `component.kubeflow.name` | Target Kubernetes resources name for this component | |
| `component.kubeflow.namespace` | Target Kubernetes namespace for this component | |
| `component.kubeflow.version` | Version of Kubeflow | `v1.2.0` |
| `component.kubeflow.tarball` | URL to kubeflow tarball archive | `https://github.com/kubeflow/manifests/archive/${component.kubeflow.version}.tar.gz` |

## See also

- TensorFlow training [overview](https://www.kubeflow.org/docs/components/training/tftraining/)
- [TesorFlow](https://www.tensorflow.org/)
