# Pipelines

## Overview of the Kubeflow pipelines service

[Kubeflow](https://www.kubeflow.org/) is a machine learning (ML) toolkit that is dedicated to making deployments of ML workflows on Kubernetes simple, portable, and scalable.

**Kubeflow pipelines** are reusable end-to-end ML workflows built using the Kubeflow Pipelines SDK.

The Kubeflow pipelines service has the following goals:

* End to end orchestration: enabling and simplifying the orchestration of end to end machine learning pipelines
* Easy experimentation: making it easy for you to try numerous ideas and techniques, and manage your various trials/experiments.
* Easy re-use: enabling you to re-use components and pipelines to quickly cobble together end to end solutions, without having to re-build each time.

Enables data scientists to define data pipelines (DAG) using notebook and python. We support only Multi-User isolation.

This component uses [argo](../argo-workflows) as the driver for pipelines.

## Dependency

Depends on:

* [`argo`](../argo-workflows): (Runtime for DAG). Argo dependency is transitive (via CRD)
* [`minio`](../minio): (DAG artifacts)
* [`mysql-pipelines`](../mysql): persistence
* [`kubeflow-profiles`](../kubeflow-profiles): (backend for multi-user isolation)
* [`kubeflow-metadata`](../kubeflow-metadata): (model outputs)

## Implementation Details

```text
./
├── crds                           # Pipeline CRD files
├── envs                           # Templates for kustomize parameters
├── patches                        # Templates to patch existing (original) kustomize resources
├── resources                      # Templates to replace existing (original) kustomize resources
├── hub-component.yaml             # Component definition file
├── kustomization.yaml.template    # Main kustomize template file
├── pre-deploy                     # Downloads tarball from kubeflow distribution webiste
└── pre-undeploy -> pre-deploy
```

This component uses Kustomize extension and follows common design guidelines for Kustomize components.

## Parameters

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `component.kubeflow.manifests.version` | Version of kubeflow deployment manifests | `v1.2.0` |
| `component.kubeflow.pipeline.multiUser` | Set's for multi user isolation | `true` |
| `component.mysql.host` | MySQL server host name | |
| `component.mysql.port` | MySQL server port (default to 3306) | `3306` |
| `component.mysql.user` | MySQL server username (cannot be empty) | |
| `component.mysql.password` | MySQL server user password (cannot be empty) | |
| `component.mysql.database` | MySQL server database (cannot be empty) | |
| `component.bucket.endpoint` | Minio endpoint expected internal endpoint (cluster.local) | |
| `component.bucket.host` | Hostname part of of the endpoint | |
| `component.bucket.port` | Minio service port | |
| `component.bucket.region` | Minio region | |
| `component.bucket.accessKey` | Minio access key id | |
| `component.bucket.secretKey` | Minio secret access key | |

## Changelog and TODOs

### Since Kubeflow v1.2

* [x] Introduced since kubeflow v1.2

> NOTE: this component has been subject of heavy changes since Kubeflow v1.3 upgrade might not be backward compatible (on infrastructure as code level)

## See Also

* Kubeflow Pipelines [overview](https://www.kubeflow.org/docs/components/pipelines/overview/pipelines-overview/)
