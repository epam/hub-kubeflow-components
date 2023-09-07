# ML Metadata

Kubeflow Pipelines backend stores runtime information of a pipeline run in Metadata store. Runtime information includes
the status of a task, availability of artifacts, custom properties associated with Execution or Artifact, etc. Learn
more at [ML Metadata Get Started](https://github.com/google/ml-metadata/blob/master/g3doc/get_started.md).

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml
components:  
  - name: kubeflow-metadata
    source:
      dir: components/kubeflow-metadata
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-metadata
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c kubeflow-metadata
```

## Requirements

- Kubernetes
- [kustomize](https://kustomize.io) CLI.
- [Kubeflow-common](../kubeflow-common)
- [MySQL](../mysql)

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name                    | Description                                    | Default Value                                                                                  | Required |
|:------------------------|:-----------------------------------------------|:-----------------------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component | `kubeflow`                                                                                     |          |
| `kubeflow.version`      | Version of Kubeflow                            | `v1.5.1`                                                                                       |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                | [kubeflow manifest](https://github.com/kubeflow/manifests/tree/master)                         |          |
| `kustomize.subpath`     | Tarball archive subpath where kustomize files are located      | [pipeline base](https://github.com/kubeflow/manifests/tree/master/apps/pipeline/upstream/base) |          |
| `mysql.host`            | MySQL database host                            |                                                                                                |          |
| `mysql.user`            | MySQL database user                            | `root`                                                                                         |          |
| `mysql.port`            | MySQL database port                            | `3306`                                                                                         |          |
| `mysql.password`        | MySQL database password                        |                                                                                                |          |
| `mysql.database`        | MySQL database database                        | `metadb`                                                                                       |          |
| `mysql.emptyPassword`   | Flag indicate that password is empty           | `#{size(component.mysql.password) == 0}`                                                       |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml          # configuration and parameters file of Hub component
└── kustomization.yaml.template # main kustomize template file
```

## See also

- [ML Metadata](https://www.kubeflow.org/docs/components/pipelines/concepts/metadata/)
- Source code of [ML Metadata](https://github.com/google/ml-metadata)
