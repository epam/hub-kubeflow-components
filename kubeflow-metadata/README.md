# ML Metadata

## Overview of the ML Metadata

Kubeflow Pipelines backend stores runtime information of a pipeline run in Metadata store. Runtime information includes the status of a task, availability of artifacts, custom properties associated with Execution or Artifact, etc. Learn more at [ML Metadata Get Started](https://github.com/google/ml-metadata/blob/master/g3doc/get_started.md).

## Implementation Details

The component has the following directory structure:

```text
./
├── db-params.env.template      # Database connection parameters template
├── db-secrets.env.template     # Database connection secrets template
├── hub-component.yaml          # Parameters definitions
├── kustomization.yaml.template # Kustomize file for ths component
├── pre-deploy                  # Script to download tarball from kubeflow distribution website and generate self-signed certs if no .certs directory
└── pre-undeploy                # Script to download tarball from kubeflow distribution website and generate self-signed certs if no .certs directory
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
| `component.mysql.host` | MySQL database host | |
| `component.mysql.port` | MySQL database port | `3306` |
| `component.mysql.user` | MySQL database user | `root` |
| `component.mysql.password` | MySQL database password | |
| `component.mysql.database` | MySQL database database | `metadb` |
| `component.mysql.emptyPassword` | Flag indicate that password is empty | `#{size(component.mysql.password) == 0}` |

## See also

- [ML Metadata](https://www.kubeflow.org/docs/components/pipelines/concepts/metadata/)
- Source code of [ML Metadata](https://github.com/google/ml-metadata)
