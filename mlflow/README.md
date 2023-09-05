# MLFlow

MLflow is an open source platform to manage the ML lifecycle, including experimentation, reproducibility, deployment,
and a central model registry. MLflow currently offers four components: MLflow Tracking, MLflow Projects, MLflow Models
and Model Registry

## TL;DR

```shell
cat << EOF > hub.yaml
version: 1
kind: stack

requires:
  - kubernetes
  
components:
  - name: mlflow
    source:
      dir: components/mlflow
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: mlflow
EOF

hubctl stack init
hubctl stack deploy      
```

## Requirements

- Kubernetes
- [kustomize](https://kustomize.io)
- [postgres](/postgresql)
- [mysql](/mysql)
- [istio-ingressgateway](/istio-ingressgateway)

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                                 | Description                                        | Default Value                        | Required 
|:-------------------------------------|:---------------------------------------------------|:-------------------------------------|:--------:|
| `kubernetes.namespace`               | Name of kubernetes namesapce where to deploy MinIO | `minio`                              |          |
| `ingress.protocol`                   | HTTP or HTTPS schema                               | `http`                               |          |
| `ingress.hosts`                      | Ingress host                                       | `${hub.componentName}.${dns.domain}` |          |
| `mlflow.version`                     | MLFlow version                                     | `2.3.0`                              |          |
| `mlflow.image.name`                  | MLFlow image name                                  | `ghcr.io/mlflow/mlflow`              |          |
| `mlflow.image.tag`                   | MLFlow image tag                                   | `v${mlflow.version}`                 |          |
| `postgresql.host`                    | Postgresql host                                    |                                      |          |
| `postgresql.user`                    | Postgresql user                                    |                                      |          |
| `postgresql.port`                    | Postgresql port                                    |                                      |          |
| `postgresql.password`                | Postgresql password                                |                                      |          |
| `postgresql.database`                | Postgresql database                                |                                      |          |
| `mysql.host`                         | Mysql host                                         |                                      |          |
| `mysql.user`                         | Mysql user                                         |                                      |          |
| `mysql.port`                         | Mysql port                                         |                                      |          |
| `mysql.password`                     | Mysql password                                     |                                      |          |
| `mysql.database`                     | Mysql database                                     |                                      |          |
| `bucket.region`                      | Storage bucket region                              | `us-east-1`                          |          |
| `bucket.endpoint`                    | Storage bucket endpoint                            |                                      |          |
| `bucket.accessKey`                   | Storage access key                                 |                                      |   `x`    |
| `bucket.secretKey`                   | Storage secret key                                 |                                      |   `x`    |
| `azure.storageAccount.name`          | Storage Account name                               |                                      |          |
| `azure.storageAccount.containerName` | Storage Account name                               |                                      |          |
| `azure.storageAccount.accessKey`     | Storage Account name                               |                                      |          |

## Implementation Details

```text
./
├── base                        # Backend for UI and operator for tensorboards
│   ├── deployment.yaml         # Deployment manifest
│   ├── kustomization.yaml      # Kustomize deployment manifest
│   └── service.yaml            # Service manifest
├── hub-component.yaml              # Configuration and parameters file of Hub component
├── ingress.yaml.gotemplate         # Helm chart template
├── kustomization.yaml.gotemplate   # Contains kustomize scr
├── post-undeploy                   # Script that is executed after undeploy of the current component
├── pre-deploy                      # Script that is executed before deploy of the current component
└── README                  
```

## See Also

* MLFlow [website](https://mlflow.org/)
