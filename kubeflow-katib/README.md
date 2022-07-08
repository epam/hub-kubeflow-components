# Katib

## Overview of the Katib

Katib is a Kubernetes-native project for automated machine learning (AutoML).
Katib supports hyperparameter tuning, early stopping and
neural architecture search (NAS).
Learn more about AutoML at [fast.ai](https://www.fast.ai/2018/07/16/auto-ml2/),
[Google Cloud](https://cloud.google.com/automl),
[Microsoft Azure](https://docs.microsoft.com/en-us/azure/machine-learning/concept-automated-ml#automl-in-azure-machine-learning) or
[Amazon SageMaker](https://aws.amazon.com/blogs/aws/amazon-sagemaker-autopilot-fully-managed-automatic-machine-learning/).

## Implementation Details

The component has the following directory structure:

```text
./
├── bin                                   # Directory contains additional component hooks
│   └── self-signed-ca.sh                 # Hook for generating self-signed certificates
├── crds                                  # Directory contains custom resource definition files
│   ├── experiment-crd.yaml               # CRD of Experiment kind
│   ├── suggestion-crd.yaml               # CRD of Suggestion kind
│   └── trial-crd.yaml                    # CRD of Trial kind
├── patches                               # Directory contains kustomize defined patches
│   └── katib-controller-deployment.yaml  # Kustomize patch
├── hub-component.yaml                    # Parameters definitions
├── kustomization.yaml.template           # Kustomize file for ths component
├── post-undeploy                         # Script to delete certificates under directory .certs
├── pre-deploy                            # Script to download tarball from kubeflow distribution website and generate self-signed certs if no .certs directory
├── pre-undeploy                          # Script to download tarball from kubeflow distribution website and generate self-signed certs if no .certs directory
└── secrets.env.template                  # Template with secrets defined as environment variables
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
| `component.kubeflow.katib.controller.image` | Katib docker image | `docker.io/kubeflowkatib/katib-controller` |
| `component.kubeflow.katib.controller.imageTag` | Katib docker image tag | `v1beta1-a96ff59` |
| `component.kubeflow.katib.ui.image` | Katib UI docker image | `docker.io/kubeflowkatib/katib-ui` |
| `component.kubeflow.katib.ui.imageTag` | Katib UI docker image tag | `v1beta1-a96ff59` |
| `component.kubeflow.katib.dbManager.image` | Katib DB manager docker image | `docker.io/kubeflowkatib/katib-db-manager` |
| `component.kubeflow.katib.dbManager.imageTag` | Katib DB manager docker image tag | `v1beta1-a96ff59` |
| `component.mysql.host` | MySQL database host | |
| `component.mysql.port` | MySQL database port | |
| `component.mysql.user` | MySQL database user | |
| `component.mysql.password` | MySQL database password | |
| `component.mysql.database` | MySQL database database | |

## See Also

- Katib [official documentation](https://www.kubeflow.org/docs/components/katib/overview/)
- Project source code on [Github](https://github.com/kubeflow/katib)
