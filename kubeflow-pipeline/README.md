# Kubeflow Pipelines

Enables data scientists to define data pipelines (DAG) using notebook and python. We support only Multi-User isolation.

This component uses [argo](../argo) as the driver for pipelines.

## Dependency

Depends on:

* `argo`: (Runtime for DAG). Argo dependency is transitive (via CRD)
* `minio`: (DAG artifacts)
* `mysql-pipelines`: persistence
* `kubeflow-profiles`: (backend for multi-user isolation)
* `kubeflow-metadata`: (model outputs)

## Implementation Details & Parameters

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

This component uses Kustomize extension and follows common design guidelines for Kustomize components

**Input parameters**

Parameter             | Description | Default value
--------------------- | ----------- | --------------
`component.kubeflow.manifests.version` | Version of kubeflow deployment manifests | v1.2.0
`component.kubeflow.pipeline.multiUser` | Set's for multi user isolation | true
`component.mysql.host` | MySQL server host name |
`component.mysql.port ` | MySQL server port (default to 3306) | 3306
`component.mysql.user` | MySQL server username (cannot be empty) |
`component.mysql.password` | MySQL server user password (cannot be empty) |
`component.mysql.database` | MySQL server database (cannot be empty) |
`component.bucket.endpoint` | Minio endpoint expected internal endpoint (cluster.local) |
`component.bucket.host` | Hostname part of of the endpoint |
`component.bucket.port` | Minio service port |
`component.bucket.region` | Minio region |
`component.bucket.accessKey` | Minio access key id |
`component.bucket.secretKey` | Minio secret access key |

## Changelog and TODOs

**Since Kubeflow v1.2**

- [x] Introduced since kubeflow v1.2

__NOTE: this component has been subject of heavy changes since Kubeflow v1.3__ upgrade might not be backward compatible (on infrastructure as code level)

## See Also

* [Getting Started](https://www.kubeflow.org/docs/components/pipelines/overview/pipelines-overview/)
* [Multi User Isolation](https://www.kubeflow.org/docs/components/pipelines/overview/pipelines-overview/)

