# Pipelines

[Kubeflow](https://www.kubeflow.org/) is a machine learning (ML) toolkit that is dedicated to making deployments of ML
workflows on Kubernetes simple, portable, and scalable.

**Kubeflow pipelines** are reusable end-to-end ML workflows built using the Kubeflow Pipelines SDK.

The Kubeflow pipelines service has the following goals:

- End to end orchestration: enabling and simplifying the orchestration of end to end machine learning pipelines
- Easy experimentation: making it easy for you to try numerous ideas and techniques, and manage your various
  trials/experiments.
- Easy re-use: enabling you to re-use components and pipelines to quickly cobble together end-to-end solutions, without
  having to re-build each time.

Enables data scientists to define data pipelines (DAG) using notebook and python. We support only Multi-User isolation.

This component uses [argo](../argo) as the driver for pipelines.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml
components:
  - name: kubeflow-pipelines
    source:
      dir: components/kubeflow-pipeline
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-pipeline
    depends:

```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c kubeflow-pipelines
```

## Requirements

- Kubernetes
- S3 Compatible store (S3, GCS or MinIO)
- [`mysql`](../mysql): persistence
- [`kubeflow-profiles`](../kubeflow-profiles): (backend for multi-user isolation)
- [`kubeflow-metadata`](../kubeflow-metadata): (model outputs)

## Parameters

| Name                           | Description                                                | Default Value                                                                                                                                                                                                    | Required |
|:-------------------------------|:-----------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`         | Kubernetes namespace for this component                    | `kubeflow`                                                                                                                                                                                                       |          |
| `kubeflow.version`             | Kubeflow version                                           | `v1.6.1`                                                                                                                                                                                                         |          |
| `kubeflow.pipelines.multiUser` | Set's for multi user isolation                             | `true`                                                                                                                                                                                                           |          |
| `kustomize.tarball.url`        | URL to kubeflow tarball archive                            | [kubeflow manifest](https://github.com/kubeflow/manifests/tree/master)                                                                                                                                           |          |
| `kustomize.subpath`            | Tarball archive subpath where kustomize files are located  | [base](https://github.com/kubeflow/manifests/tree/master/apps/pipeline/upstream/base) [metacontroller](https://github.com/kubeflow/manifests/tree/master/apps/pipeline/upstream/third-party/metacontroller/base) |          |
| `mysql.host`                   | MySQL server host name                                     |                                                                                                                                                                                                                  |          |
| `mysql.port`                   | MySQL server port                                          | `3306`                                                                                                                                                                                                           |          |
| `mysql.user`                   | MySQL server username                                      |                                                                                                                                                                                                                  |   `x`    |
| `mysql.password`               | MySQL server user password                                 |                                                                                                                                                                                                                  |   `x`    |
| `mysql.database`               | MySQL server database                                      |                                                                                                                                                                                                                  |   `x`    |
| `bucket.endpoint`              | Bucket endpoint expected internal endpoint (cluster.local) |                                                                                                                                                                                                                  |          |
| `bucket.region`                | Bucket region                                              |                                                                                                                                                                                                                  |          |
| `bucket.accessKey`             | Bucket access key id                                       |                                                                                                                                                                                                                  |          |
| `bucket.secretKey`             | Bucket secret access key                                   |                                                                                                                                                                                                                  |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── envs                           # templates for kustomize parameters
│   ├── params-api-service.env.template
│   ├── params-install-config.env.template
│   └── params-pipeline-ui.env.template
├── patches                        # templates to patch existing (original) kustomize resources
│   ├── metadata-writer-role.yaml
│   └── pipeline-ui-deployment.yaml
├── resources                      # templates to replace existing (original) kustomize resources
│   └── default-editor.yaml.template 
├── hub-component.yaml             # configuration and parameters file of Hub component
├── kustomization.yaml.template    # main kustomize template file
```

This component uses Kustomize extension and follows common design guidelines for Kustomize components.

## See Also

- Kubeflow Pipelines [overview](https://www.kubeflow.org/docs/components/pipelines/overview/pipelines-overview/)
- [Minio](https://min.io/)
- [Minio Component](https://github.com/epam/hub-kubeflow-components/tree/develop/minio)
- [S3 Bucket Component](https://github.com/epam/hub-kubeflow-components/tree/develop/s3-bucket)
- [GCS Bucket Component](https://github.com/epam/hub-google-components/tree/develop/gsbucket)