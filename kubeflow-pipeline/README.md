# Pipelines

[Kubeflow](https://www.kubeflow.org/) is a machine learning (ML) toolkit that is dedicated to making deployments of ML
workflows on Kubernetes simple, portable, and scalable.

**Kubeflow pipelines** are reusable end-to-end ML workflows built using the Kubeflow Pipelines SDK.

The Kubeflow pipelines service has the following goals:

* End to end orchestration: enabling and simplifying the orchestration of end to end machine learning pipelines
* Easy experimentation: making it easy for you to try numerous ideas and techniques, and manage your various
  trials/experiments.
* Easy re-use: enabling you to re-use components and pipelines to quickly cobble together end to end solutions, without
  having to re-build each time.

Enables data scientists to define data pipelines (DAG) using notebook and python. We support only Multi-User isolation.

This component uses [argo](../argo-workflows) as the driver for pipelines.

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
  - name: kubeflow-pipelines
    source:
      dir: components/kubeflow-pipeline
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-pipeline
    depends:
      - kubeflow-profiles
      - kubeflow-metadata
      - mysql-metadata
      - minio 
EOF

hubctl stack init
hubctl stack deploy
```

## Requirements

* Kubernetes
* [`minio`](../minio): (DAG artifacts)
* [`mysql-pipelines`](../mysql): persistence
* [`kubeflow-profiles`](../kubeflow-profiles): (backend for multi-user isolation)
* [`kubeflow-metadata`](../kubeflow-metadata): (model outputs)

## Parameters

| Name                           | Description                                               | Default Value                                                                                             | Required 
|:-------------------------------|:----------------------------------------------------------|:----------------------------------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`         | Target Kubernetes namespace for this component            | `kubeflow`                                                                                                |          |
| `kubeflow.name`                | Name of Kubeflow component                                | `kubeflow-pipelines`                                                                                      |          |
| `kubeflow.version`             | Version of Kubeflow                                       | `v1.6.1`                                                                                                  |          |
| `kubeflow.pipelines.multiUser` | Set's for multi user isolation                            | `true`                                                                                                    |          |
| `kustomize.tarball.url`        | URL to kubeflow tarball archive                           | `https://codeload.github.com/kubeflow/manifests/tar.gz/${kubeflow.version}`                               |          |
| `kustomize.subpath`            | Directories from kubeflow tarball archive                 | `apps/pipeline/upstream/base: apps/pipeline/upstream/third-party/metacontroller/base:crds/metacontroller` |          |
| `mysql.host`                   | MySQL server host name                                    |                                                                                                           |          |
| `mysql.port`                   | MySQL server port (default to 3306)                       | `3306`                                                                                                    |          |
| `mysql.user`                   | MySQL server username (cannot be empty)                   |                                                                                                           |          |
| `mysql.password`               | MySQL server user password (cannot be empty)              |                                                                                                           |          |
| `mysql.database`               | MySQL server database (cannot be empty)                   |                                                                                                           |          |
| `bucket.endpoint`              | Minio endpoint expected internal endpoint (cluster.local) |                                                                                                           |          |
| `bucket.host`                  | Hostname part of the endpoint                             |                                                                                                           |          |
| `bucket.port`                  | Minio service port                                        |                                                                                                           |          |
| `bucket.region`                | Minio region                                              |                                                                                                           |          |
| `bucket.accessKey`             | Minio access key id                                       |                                                                                                           |          |
| `bucket.secretKey`             | Minio secret access key                                   |                                                                                                           |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── envs                           # Templates for kustomize parameters
│   ├── params-api-service.env.template
│   ├── params-install-config.env.template
│   └── params-pipeline-ui.env.template
├── patches                        # Templates to patch existing (original) kustomize resources
│   ├── metadata-writer-role.yaml
│   └── pipeline-ui-deployment.yaml
├── resources                      # Templates to replace existing (original) kustomize resources
│   └── default-editor.yaml.template 
├── hub-component.yaml             # Component definition file
├── kustomization.yaml.template    # Main kustomize template file
```

This component uses Kustomize extension and follows common design guidelines for Kustomize components.

## See Also

* Kubeflow Pipelines [overview](https://www.kubeflow.org/docs/components/pipelines/overview/pipelines-overview/)
