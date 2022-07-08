# MinIO

## Overview of the MinIO

MinIO is a Kubernetes-native object store designed to provide high performance with an S3-compatible API.

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml              # Component definition
├── values-ingress.yaml.gotemplate  # Helm chart ingress value template
└── values.yaml.template            # Helm chart value template
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `component.ingress.protocol` | HTTP or HTTPS schema | `http` |
| `component.ingress.host` | Ingress host | `${hub.componentName}.${dns.domain}` |
| `component.ingress.class` | Name of ingress class in kubernetes | |
| `component.bucket.region` | Storage bucket region  | `us-east-1` |
| `component.bucket.name` | Storage bucket name | `default` |
| `component.storage-class.name` | Name of kubernetes storage class | `default` |
| `component.minio.accessKey` | MinIO access key | |
| `component.minio.secretKey` | MinIO secret key | |
| `component.minio.namespace` | Name of kubernetes namesapce where to deploy MinIO | `minio` |
| `component.minio.replicas` | Amount of MinIO replicas | `4` |
| `component.minio.volumeType` | Persistence volume type | `gp2` |
| `component.minio.existingClaim` | A manually managed Persistent Volume and Claim | |
| `component.minio.storageSize` | Storage size | `20Gi` |
| `component.minio.requests.memory` | Resource memory request | `4Gi` |
| `component.minio.mode` | MinIO mode, i.e. standalone or distributed or gateway | `distributed` |
| `component.minio.requests.ram` | | `1Gi` |
| `helm.repo` | Helm chart repository URL | `https://charts.min.io/` |
| `helm.chart` | Helm chart name | `minio` |
| `helm.version` | Helm chart version | `4.0.2` |
| `helm.baseValuesFile` | Helm base values file | `values.yaml` |
| `helm.logLevel` | Helm log level | `info` |
| `docker.image` | MinIO docker image | `quay.io/minio/minio` |
| `docker.tag` | MinIO docker image tag | `RELEASE.2022-06-02T02-11-04Z` |
| `docker.mcImage` | MinIO client docker image | `quay.io/minio/mc` |
| `docker.mcTag` | MinIO client docker image tag | |
| `docker.jqImage` | JQ docker image | `bskim45/helm-kubectl-jq` |
| `docker.jqTag` | JQ docker image tag | `3.1.0` |

## See Also

* [MinIO](https://min.io/)
* MinIO documentation for [Hybrid Cloud](https://docs.min.io/minio/k8s/)
