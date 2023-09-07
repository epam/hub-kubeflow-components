# TensorFlow Training

TFJob is a Kubernetes custom resource to
run [TensorFlow training](https://www.kubeflow.org/docs/components/training/tftraining/) jobs on Kubernetes. The
Kubeflow implementation of TFJob is in training-operator.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml
components:
  - name: kubeflow-tf-training
    source:
      dir: components/kubeflow-tf-training
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-tf-training
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy -c kubeflow-tf-training
```

## Requirements

- Kubernetes
- [kustomize](https://kustomize.io) CLI.

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name                    | Description                             | Default Value                                                          | Required |
|-------------------------|-----------------------------------------|------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Kubernetes namespace for this component | `kubeflow`                                                             |          |
| `kubeflow.version`      | Kubeflow version                        | `v1.2.0`                                                               |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive         | [kubeflow manifest](https://github.com/kubeflow/manifests/tree/master) |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── crds                              # directory contains custom resource definition files
│   └── tfjobs.yaml                   # CRD of TFJob kind
├── hub-component.yaml                # configuration and parameters file of Hub component
├── kustomization.yaml.template       # main kustomize template file
├── pre-deploy                        # script to download tarball from kubeflow distribution website
└── pre-undeploy -> pre-deploy        # symlink to support undeploy
```

## See also

- TensorFlow training [overview](https://www.kubeflow.org/docs/components/training/tftraining/)
- [TensorFlow](https://www.tensorflow.org/)
