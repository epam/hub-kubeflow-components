# Katib

Katib is a Kubernetes-native project for automated machine learning (AutoML).
Katib supports hyperparameter tuning, early stopping and neural architecture search (NAS).

## TL;DR

Set environment variables `MYSQL_HOST`,`MYSQL_USER`,`MYSQL_PORT`,`MYSQL_PASSWORD`,`MYSQL_DATABASE`.   
Declare hubctl stack

```shell
cat << EOF > params.yaml
parameters:
- name: mysql
  parameters:
  - name: host
    fromEnv: MYSQL_HOST
  - name: user
    fromEnv: MYSQL_USER
  - name: port
    value: MYSQL_PORT
  - name: password
    fromEnv: MYSQL_PASSWORD
  - name: database
    fromEnv: MYSQL_DATABASE
EOF

cat << EOF > hub.yaml
version: 1
kind: stack

requires:
  - kubernetes

extensions:
  include:
    - params.yaml

components:  
  - name: kubeflow-katib
    source:
      dir: components/kubeflow-katib
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-katib
    depends:
      - kubeflow-common
      - mysql-katib  
EOF

hubctl stack init
hubctl stack deploy
```

## Requirements

- Kubernetes
- [kustomize](https://kustomize.io) CLI
- [Kubeflow-common](../kubeflow-common/README) component
- [MySQL](../mysql/README) component

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name                   | Description                                    | Default Value                                                                        | Required |
|:-----------------------|:-----------------------------------------------|:-------------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace` | Target Kubernetes namespace for this component | `kubeflow`                                                                           |          |
| `kubeflow.version`     | Version of Kubeflow                            | `v1.5.1`                                                                             |          |
| `kubeflow.tarball`     | URL to kubeflow tarball archive                | `https://github.com/kubeflow/manifests/archive/${component.kubeflow.version}.tar.gz` |          |
| `kubeflow.subpath`     | Directories from kubeflow tarball archive      | `apps/katib/upstream`                                                                |          |
| `mysql.host`           | MySQL database host                            |                                                                                      |    x     |
| `mysql.port`           | MySQL database port                            |                                                                                      |    x     |
| `mysql.user`           | MySQL database user                            |                                                                                      |    x     |
| `mysql.password`       | MySQL database password                        |                                                                                      |    x     |
| `mysql.database`       | MySQL database name                            |                                                                                      |    x     |

## Implementation Details

The component has the following directory structure:

```text
./
├── bin                                   # Directory contains additional component hooks
│   └── self-signed-ca.sh                 # Hook for generating self-signed certificates
├── hub-component.yaml                    # Parameters definitions
├── kustomization.yaml.template           # Kustomize file for this component
└── pre-deploy                            # Script to download tarball from kubeflow distribution website and generate self-signed certs if no .certs directory
```

`pre-deploy` runs hook for generating certificates

## See Also

- Katib [official documentation](https://www.kubeflow.org/docs/components/katib/overview/)
- Project source code on [Github](https://github.com/kubeflow/katib)
- Learn more about AutoML
  at [fast.ai](https://www.fast.ai/2018/07/16/auto-ml2/), [Google Cloud](https://cloud.google.com/automl), [Microsoft Azure](https://docs.microsoft.com/en-us/azure/machine-learning/concept-automated-ml#automl-in-azure-machine-learning), [Amazon SageMaker](https://aws.amazon.com/blogs/aws/amazon-sagemaker-autopilot-fully-managed-automatic-machine-learning/)
