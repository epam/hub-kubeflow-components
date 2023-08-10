# MinIO

MinIO is a Kubernetes-native object store designed to S3 compatible storage for cloud-native workloads

## Dependencies

* [Helm](https://helm.sh/docs/intro/install/)

## Requirements

* Kubernetes

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name | Description | Default Value | Required |
| :--- | :---        | :---          | :---:     |
| `bucket.name` | Storage bucket name | `default` | `x` |
| `bucket.accessKey` | MinIO access key | | `x` |
| `bucket.secretKey` | MinIO secret key | | `x` |
| `bucket.region` | Storage bucket region  | `us-east-1` | `x` |
| `bucket.acl` | Bucket policy see [here](https://min.io/docs/minio/linux/administration/identity-access-management/policy-based-access-control.html)  | `none` | `x` |
| `minio.mode` | MinIO mode, i.e. standalone or distributed or gateway |  `distributed or standalone if kubernetes.replicas = 1` | `x` |
| `minio.logLevel` | Log level for minio container | `info` | `x` |
| `ingress.protocol` | HTTP or HTTPS schema | `http` | |
| `ingress.hosts` | Space separated list of hosts for ingress | | | 
| `ingress.class` | Name of ingress class in kubernetes | | |
| `kubernetes.namespace` | Name of kubernetes namesapce where to deploy MinIO | `minio` | `x` |
| `kubernetes.replicas` | Amount of MinIO replicas | `4` | `x` |
| `kubernetes.requests` | Kubernetes requests in the format: space separated list of `key=value` | `memory=1Gi` | |
| `storage.class` | Name of kubernetes storage class | | |
| `storage.claim` | A manually managed Persistent Volume and Claim | | |
| `storage.size` | Storage size | `20Gi` | |
| `helm.repo` | Helm chart repository URL | `https://charts.min.io/` | `x` |
| `helm.chart` | Helm chart name | `minio` | `x` |
| `helm.version` | Helm chart version | `4.0.2` | `x` |
| `helm.baseValuesFile` | Helm base values file | `values.yaml` | `x` |
| `docker.image` | MinIO docker image | `quay.io/minio/minio` | `x` |
| `docker.tag` | MinIO docker image tag | `RELEASE.2022-06-02T02-11-04Z` | `x` |
| `docker.mcImage` | MinIO client docker image | `quay.io/minio/mc` | `x` |
| `docker.mcTag` | MinIO client docker image tag | | `x` |
| `docker.jqImage` | JQ docker image | `bskim45/helm-kubectl-jq` | `x` |
| `docker.jqTag` | JQ docker image tag | `3.1.0` | `x` |

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml              # Component definition
├── values-ingress.yaml.gotemplate  # Ingress specific helm chart values 
└── values.yaml.gotemplate          # Helm chart value template
```

### Minio Mode

Parameter `minio.mode` is a `cel` expression: it can be either `distributed` or `standalone` depending on the value of `kubernetes.replicas` parameter. Another allowed parameter `gateway` is not supported yet.

## Ingress

Leave `ingress.hosts` empty if you don't want to deploy ingress resource

> Note: nginx parameters are deprecated and will be moved to the `pre-deploy` hooks at the stack level

## See Also

* [S3 Component](https://github.com/epam/hub-kubeflow-components/tree/develop/s3-bucket)
* [GS Bucket Component](https://github.com/epam/hub-google-components/tree/develop/gsbucket)
* [MinIO](https://min.io/)
* MinIO documentation for [Hybrid Cloud](https://docs.min.io/minio/k8s/)
