# Argo Workflows

Argo Workflows is an open source container-native workflow engine for orchestrating parallel jobs on Kubernetes. Argo Workflows is implemented as a Kubernetes CRD.

* Define workflows where each step in the workflow is a container.
* Model multi-step workflows as a sequence of tasks or capture the dependencies between tasks using a graph (DAG).
* Easily run compute intensive jobs for machine learning or data processing in a fraction of the time using Argo Workflows on Kubernetes.
* Run CI/CD pipelines natively on Kubernetes without configuring complex software development products.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml`file
```yaml
  - name: argo
    source:
      dir: components/argo
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: argo
```

To initiate the deployment, run the following commands:
```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c argo
```

## Requirements

- [Helm](https://helm.sh/docs/intro/install/)
- S3 Compatible store (S3, GCS or MinIO)
- Azure Container Storage (not S3 compatible but can be used as alternative to S3)

## Parameters
The following component level parameters can be set in `hub-component.yaml`:

| Name | Description | Default Value | Required |
|:---- |:----------- | :-------------: |:------:|
|`kubernetes.namespace` | Kubernetes namespace where Argo is provisioned |`argo`|
|`kubernetes.version`   | Version of Argo | `v3.4.3` |
| `argo.workflowNamespace` | Default namespace for argo wofkflows | `${kubernetes.namespace}` |
| `argo.server.authMode` | Whitespace separated list of Argo auth modes | `client server` |
| `helm.repo`    | Helm chart repository | [argoproj](https://argoproj.github.io/argo-helm) |
| `helm.chart`   | Helm chart name | `argo-workflows` |
| `helm.version` | Helm version | `v1.11.1`|
| `helm.baseValuesFile` | Instructs hubctl to reuse values file from helm chart as base |`values.yaml` |
| `helm.crd` | URL to install CRDs |`values.yaml` | [github](https://github.com/argoproj/argo-workflows/tree/master/manifests/base/crds/minimal) |
| `ingress.protocol` | Ingress traffic protocol (scheme) | `http` |
| `ingress.hosts`    | Whitespace separated list of hosts for ingress. Empty means no ingress should be created| |
| `bucket.name` | S3 Bucket name to be used as Argo artifact storage. Empty means: do not use s3 storage | |
| `bucket.endpoint` | Fully qualified URL for S3 bucket service, this URL should include sheme, host and port (e.g. `http://minio:9000`) | |
| `bucket.region`   | S3 bucket region | `us-east-1` (default region for minio) |
| `bucket.accessKey` | Static access key for S3 bucket | |
| `bucket.secretKey` | Static secret key for the S3 bucket  | |
| `azure.storageAccount.name`          | Account name of Azure storage. Empty means do not use azure storage account for Ago artifact store | |
| `azure.storageAccount.containerName` | Container name of Azure storage | |
| `azure.storageAccount.accessKey`     | Access key of Azure storage | |
| `hub.backup.file` | Local path to backup file | |

## Implementation Details

The Argo Workflows Component has the following directory structure:

```text
./
├── resources/                      # Kubernetes resources that managed outside of Helm
├── hub-component.yaml              # configuration and parameters file of Hub component
├── values.yaml.gotemplate          # gotemplate of Helm's values.yaml file
├── values-s3.yaml.gotemplate       # contains values for s3 artifact storage configurartion
├── values-azure.yaml.gotemplate    # contains values for azure artifact storage configurartion
├── pre-deploy                      # checks if at leat one artifact store is configured
├── post-deploy                     # handles restore from backup logic
├── post-undeploy                   # cleanup artifact store bucket secrets
└── backup                          # shell script that contains backup routines
```

Deployment follows to the following algorithm:

1. To run Argo workflows that use artifacts, you must configure and use an artifact repository. Argo supports any S3 compatible artifact repository such as AWS, GCS and MinIO. At the beginning hubctl need to create compatible storage component for Argo.
2. The `pre-deploy` defines an alias or variable named kubectl that includes context and namespace information. It sets up the kubectl command to work within a specific context and namespace in a Kubernetes cluster.
3. Then start deployment
4. The `post-deploy` script checks if a backup file exists, and if it does, it proceeds to restore its contents into a temporary directory and creates Kubernetes resources from those contents using kubectl. It takes care of cleaning up the temporary directory when the script exits.

### Artifact Store

Argo is using Object Store to pass artifacts between steps of the workflow. This component supports two types of store.

* S3 compatible store (includes S3, GCS and MinIO)
* Azure Container Storage (not S3 compatible but supported by Argo)

> IMPORTANT: at least one store must be configured to run Argo workflows

### Customize Argo Image

Argo executor is one of of the common source when user will want to use alternative image. To customize Argo executor image you need to add a hook `bin/argo-executor` and add execution rights to it.

```bash
#!/bin/sh -e
cat <<EOF > values-generated.yaml
executor:
  image:
    registry: "quay.io"
    repository: "argoproj/argoexec"
    tag: "latest"
    pullPolicy: ""
EOF
```

Refer hook in the `hub.yaml` file

```yaml
components:
- name: argo
  # ...
  hooks:
  - file: bin/argo-executor
    triggers: [pre-deploy, pre-undeploy]
```

### Additional Values

This component used helm chart hosted by Argo project. You can find all available values in the [helm value](https://github.com/argoproj/argo-helm/blob/main/charts/argo-workflows/values.yaml).

To define extra values, use  deployment hook from the article [above](#customize-argo-image)

## See also

* [Argo Workflows](https://argoproj.github.io/argo-workflows/)
* [Minio](https://min.io/)
* [Minio Component](https://github.com/epam/hub-kubeflow-components/tree/develop/minio)
* [S3 Bucket Component](https://github.com/epam/hub-kubeflow-components/tree/develop/s3-bucket)
* [GCS Bucket Component](https://github.com/epam/hub-google-components/tree/develop/gsbucket)
* [Azure Container Storage Account](https://github.com/epam/hub-azure-components/tree/main/azure-storage-account)
