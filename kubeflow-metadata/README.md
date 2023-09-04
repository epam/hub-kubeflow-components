# ML Metadata

Kubeflow Pipelines backend stores runtime information of a pipeline run in Metadata store. Runtime information includes
the status of a task, availability of artifacts, custom properties associated with Execution or Artifact, etc. Learn
more at [ML Metadata Get Started](https://github.com/google/ml-metadata/blob/master/g3doc/get_started.md).

## TL;DR

Set environment variables `MYSQL_HOST`,`MYSQL_USER`,`MYSQL_PORT`,`MYSQL_PASSWORD`,`MYSQL_DATABASE`.
Declare hubctl stack with

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
  - name: kubeflow-metadata
    source:
      dir: components/kubeflow-metadata
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-metadata
    depends:
      - kubeflow-common
      - mysql-metadata
EOF

hubctl stack init
hubctl stack deploy
```

## Requirements

- Kubernetes
- [kustomize](https://kustomize.io) CLI.
- [Kubeflow-common](../kubeflow-common/README) component
- [MySQL](../mysql/README) component

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name                    | Description                                    | Default Value                                                               | Required |
|:------------------------|:-----------------------------------------------|:----------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component | `kubeflow`                                                                  |          |
| `kubeflow.version`      | Version of Kubeflow                            | `v1.5.1`                                                                    |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                | `https://codeload.github.com/kubeflow/manifests/tar.gz/${kubeflow.version}` |          |
| `kustomize.subpath`     | Directories from kubeflow tarball archive      | `apps/pipeline/upstream/base`                                               |          |
| `mysql.host`            | MySQL database host                            |                                                                             |          |
| `mysql.user`            | MySQL database user                            | `root`                                                                      |          |
| `mysql.port`            | MySQL database port                            | `3306`                                                                      |          |
| `mysql.password`        | MySQL database password                        |                                                                             |          |
| `mysql.database`        | MySQL database database                        | `metadb`                                                                    |          |
| `mysql.emptyPassword`   | Flag indicate that password is empty           | `#{size(component.mysql.password) == 0}`                                    |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml          # Parameters definitions
├── kustomization.yaml.template # Kustomize file for ths component
└── README                      
```

## See also

- [ML Metadata](https://www.kubeflow.org/docs/components/pipelines/concepts/metadata/)
- Source code of [ML Metadata](https://github.com/google/ml-metadata)
