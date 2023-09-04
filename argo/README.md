# Argo Workflows

Argo Workflows is an open source container-native workflow engine for orchestrating parallel jobs on Kubernetes. Argo Workflows is implemented as a Kubernetes CRD.
* Define workflows where each step in the workflow is a container.
* Model multi-step workflows as a sequence of tasks or capture the dependencies between tasks using a graph (DAG).
* Easily run compute intensive jobs for machine learning or data processing in a fraction of the time using Argo Workflows on Kubernetes.
* Run CI/CD pipelines natively on Kubernetes without configuring complex software development products.

## TLDR

```yaml
  - name: argo
    source:
      dir: components/argo
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: argo
  
```

## Requirements

- Helm
- Kubernetes
- Minio or s3-bucket component 

## Parameters

| Name                                 | Description                                               | Default Value                          | Required |
|--------------------------------------|-----------------------------------------------------------|----------------------------------------|:--------:|
| `kubernetes.namespace`               | Kubernetes namespace where Argo is provisioned            | `kube-argo`                            |          |
| `kubernetes.version`                 | Kubernetes of Argo version                                | `v3.4.3`                               |          |
| `argo.workflowNamespace`             | Kubernetes namespace where workflow workloads are created | `${kubernetes.namespace}`              |          |
| `argo.executor.registry`             | The Docker registry of the executor image                 | `quay.io`                              |          |
| `argo.executor.repository`           | The Docker repository of the executor image               | `argoproj/argoexec`                    |          |
| `argo.executor.tag`                  | This specifies the tag of the executor                    | `argoproj/argoexec`                    |          |
| `helm.repo`                          | Helm chart repo                                           | `https://argoproj.github.io/argo-helm` |          |
| `helm.chart`                         | Helm chart name                                           | `argo-workflows`                       |          |
| `helm.version`                       | Helm version                                              | `v1.11.1`                              |          |
| `helm.valuesFile`                    | Helm values file                                          | `values.yaml`                          |          |
| `ingress.protocol`                   | Ingress traffic protocol (schema)                         | `http`                                 |          |
| `ingress.hosts`                      | List of ingress hosts (Note: only first will be used)     |                                        |          |
| `bucket.host`                        | Hostname part of of the endpoint                          |                                        |          |
| `bucket.port`                        | Bucket service port                                       |                                        |          |
| `bucket.region`                      | Bucket region                                             | `${cloud.region}`                      |          |
| `bucket.accessKey`                   | Access key for the Minio bucket                           |                                        |          |
| `bucket.secretKey`                   | Secret key for the Minio bucket                           |                                        |          |
| `bucket.name`                        | Bucket name                                               | `${hub.stackName}`                     |          |
| `azure.storageAccount.name`          | Account name of Azure storage                             |                                        |          |
| `azure.storageAccount.containerName` | Container name of Azure storage                           |                                        |          |
| `azure.storageAccount.accessKey`     | Access key of Azure storage                               |                                        |          |
| `hub.backup.file`                    | Profiles backup file                                      |                                        |          |

## Implementation Details

The Argo Workflows Component has the following directory structure:

```text
./
├── hub-component.yaml              # configuration and parameters file of Hub component
├── values.yaml.gotemplate          # gotemplate of Helm's values.yaml file
├── values-executor.yaml.template   # template of executor for Helm's values.yaml file
├── post-deploy                     # script that is executed after deploy of the current component
├── post-undeploy                   # script that is executed after undeploy of the current component
├── pre-deploy                      # script that is executed before deploy of the current component
├── resources/                      # component custom resource descriptors
└── backup                          # shell script that contains backup routines
```

Deployment follows to the following algorithm:
1. To run Argo workflows that use artifacts, you must configure and use an artifact repository. Argo supports any S3 compatible artifact repository such as AWS, GCS and MinIO. At the beginning hubctl need to create compatible storage component for Argo.
2. The `pre-deploy` defines an alias or variable named kubectl that includes context and namespace information. It sets up the kubectl command to work within a specific context and namespace in a Kubernetes cluster.
3. Then start deployment
4. The `post-deploy` script checks if a backup file exists, and if it does, it proceeds to restore its contents into a temporary directory and creates Kubernetes resources from those contents using kubectl. It takes care of cleaning up the temporary directory when the script exits.


## See also

* [Argo Workflows](https://argoproj.github.io/argo-workflows/)
* [Helm](https://helm.sh/docs/intro/install/)
* [Helm Chart](https://artifacthub.io/packages/helm/argo/argo-workflows/0.9.4)
* [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/)
* [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine)
* [hub cli](https://github.com/agilestacks/hub/wiki)

