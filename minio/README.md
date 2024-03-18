# MinIO

MinIO is a Kubernetes-native object store designed to S3 compatible storage for cloud-native workloads

## Requirements

* Kubernetes
* [Helm](https://helm.sh/docs/intro/install/)

## TL;DR

To define this component within your stack. Add the followings to your `hub.yaml` file

* Include the configuration of Kubernetes

```yaml
extensions:
  configure:
    - kubernetes
```

* Define minio component under the `components` section

```yaml
components:
  - name: minio
    source:
      dir: components/minio
      git:
        remote: https://github.com/epam/hub-kubeflow-components.git
        subDir: minio
```

* Define parameters under the `parameters` section

```yaml
parameters:
  - name: bucket
    parameters:
      - name: accessKey
        fromEnv: MINIO_ACCESS_KEY
      - name: secretKey
        fromEnv: MINIO_SECRET_KEY
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy minio
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                   | Description                                                                                                                          | Default Value                                           | Required |
|:---                    |:---                                                                                                                                  |:---                                                     |:---     :|
| `bucket.name`          | Storage bucket name                                                                                                                  | `default`                                               |          |
| `bucket.accessKey`     | MinIO root access key                                                                                                                |                                                         |   `x`    |
| `bucket.secretKey`     | MinIO root secret key                                                                                                                |                                                         |   `x`    |
| `bucket.region`        | Storage bucket region                                                                                                                | `us-east-1`                                             |          |
| `bucket.acl`           | Bucket policy see [here](https://min.io/docs/minio/linux/administration/identity-access-management/policy-based-access-control.html) | `none`                                                  |          |
| `minio.mode`           | MinIO mode, i.e. standalone or distributed or gateway                                                                                | `standalone or distributed if kubernetes.replicas >= 4` |          |
| `minio.logLevel`       | Log level for minio container                                                                                                        | `info`                                                  |          |
| `minio.server.image`   | MinIO server docker image                                                                                                            | `quay.io/minio/minio`                                   |          |
| `minio.server.tag`     | MinIO server docker image tag                                                                                                        | `RELEASE.2024-01-11T07-46-16Z`                          |          |
| `minio.client.image`   | MinIO client docker image                                                                                                            | `quay.io/minio/mc`                                      |          |
| `minio.client.tag`     | MinIO client docker image tag                                                                                                        | `RELEASE.2024-01-11T05-49-32Z`                          |          |
| `ingress.protocol`     | HTTP or HTTPS schema                                                                                                                 | `http`                                                  |          |
| `ingress.hosts`        | Space separated list of hosts for ingress                                                                                            |                                                         |          |
| `ingress.class`        | Name of ingress class in kubernetes                                                                                                  |                                                         |          |
| `kubernetes.namespace` | Name of kubernetes namespace where to deploy MinIO                                                                                   | `minio`                                                 |          |
| `kubernetes.replicas`  | Amount of MinIO replicas                                                                                                             | `4`                                                     |          |
| `kubernetes.requests`  | Kubernetes requests in the format: space separated list of `key=value`                                                               | `memory=1Gi`                                            |          |
| `storage.class`        | Name of kubernetes storage class                                                                                                     |                                                         |          |
| `storage.claim`        | A manually managed Persistent Volume and Claim                                                                                       |                                                         |          |
| `storage.size`         | Storage size                                                                                                                         | `20Gi`                                                  |          |
| `helm.repo`            | Helm chart repository URL                                                                                                            | `https://charts.min.io/`                                |          |
| `helm.chart`           | Helm chart name                                                                                                                      | `minio`                                                 |          |
| `helm.version`         | Helm chart version                                                                                                                   | `5.0.15`                                                |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml              # configuration and parameters file of Hub component
├── values-ingress.yaml.gotemplate  # ingress specific helm chart values
└── values.yaml.gotemplate          # helm chart value template
```

This component will be installed using Helm. By default, we rely on Bitnami distribution of helm chart as a quality
helm chart with lots of improvements and hardening.

### Minio Mode

Parameter `minio.mode` is a `cel` expression: it can be either `distributed` or `standalone` depending on the value
of `kubernetes.replicas` parameter.

## Ingress

Leave `ingress.hosts` empty if you don't want to deploy ingress resource

> Note: nginx parameters are deprecated and will be moved to the `pre-deploy` hooks at the stack level

## See Also

* [S3 Component](https://github.com/epam/hub-kubeflow-components/tree/develop/s3-bucket)
* [GS Bucket Component](https://github.com/epam/hub-google-components/tree/develop/gsbucket)
* [MinIO](https://min.io/)
* MinIO documentation for [Hybrid Cloud](https://docs.min.io/minio/k8s/)
