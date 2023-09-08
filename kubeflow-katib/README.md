# Katib

Katib is a Kubernetes-native project for automated machine learning (AutoML).
Katib supports hyperparameter tuning, early stopping and neural architecture search (NAS).

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml
components:
  - name: kubeflow-katib
    source:
      dir: components/kubeflow-katib
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-katib
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c kubeflow-katib
```

## Requirements

- Kubernetes
- [Kustomize](https://kustomize.io) CLI
- [Kubeflow-common](../kubeflow-common)
- [MySQL](../mysql)

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name                    | Description                                               | Default Value                                                                  | Required |
|:------------------------|:----------------------------------------------------------|:-------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component            | `kubeflow`                                                                     |          |
| `kubeflow.version`      | Kubeflow version                                          | `v1.6.1`                                                                       |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                           | [kubeflow manifest](https://github.com/kubeflow/manifests/tree/master)         |          |
| `kustomize.subpath`     | Tarball archive subpath where kustomize files are located | [katib](https://github.com/kubeflow/manifests/tree/master/apps/katib/upstream) |          |
| `mysql.host`            | MySQL database host                                       |                                                                                |   `x`    |
| `mysql.port`            | MySQL database port                                       |                                                                                |   `x`    |
| `mysql.user`            | MySQL database user                                       |                                                                                |   `x`    |
| `mysql.password`        | MySQL database password                                   |                                                                                |   `x`    |
| `mysql.database`        | MySQL database name                                       |                                                                                |   `x`    |

## Implementation Details

The component has the following directory structure:

```text
./
├── bin                                   # directory contains additional component hooks
│   └── self-signed-ca.sh                 # hook for generating self-signed certificates
├── hub-component.yaml                    # parameters definitions
├── kustomization.yaml.template           # kustomize file for this component
└── pre-deploy                            # script to download tarball from kubeflow distribution website and generate self-signed certs if no .certs directory
```

`pre-deploy` runs hook for generating certificates

## See Also

- Katib [official documentation](https://www.kubeflow.org/docs/components/katib/overview/)
- Project source code on [Github](https://github.com/kubeflow/katib)
- Learn more about AutoML
  at [fast.ai](https://www.fast.ai/2018/07/16/auto-ml2/), [Google Cloud](https://cloud.google.com/automl), [Microsoft Azure](https://docs.microsoft.com/en-us/azure/machine-learning/concept-automated-ml#automl-in-azure-machine-learning), [Amazon SageMaker](https://aws.amazon.com/blogs/aws/amazon-sagemaker-autopilot-fully-managed-automatic-machine-learning/)
