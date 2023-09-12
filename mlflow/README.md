# MLFlow

MLflow is an open source platform to manage the ML lifecycle, including experimentation, reproducibility, deployment,
and a central model registry. MLflow currently offers four components: MLflow Tracking, MLflow Projects, MLflow Models
and Model Registry

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml  
components:
  - name: mlflow
    source:
      dir: components/mlflow
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: mlflow
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy -c mlflow
```

## Requirements

- Kubernetes
- [Kustomize](https://kustomize.io)
- [Postgresql](../postgresql)
- [Mysql](../mysql)
- [Istio-ingressgateway](../istio-ingressgateway)

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                                 | Description                             | Default Value                        | Required |
|:-------------------------------------|:----------------------------------------|:-------------------------------------|:--------:|
| `kubernetes.namespace`               | Kubernetes namespace for this component | `mlflow`                             |          |
| `ingress.protocol`                   | HTTP or HTTPS schema                    | `http`                               |          |
| `ingress.hosts`                      | Ingress host                            | `${hub.componentName}.${dns.domain}` |          |
| `mlflow.version`                     | MLFlow version                          | `2.3.0`                              |          |
| `mlflow.image.name`                  | MLFlow image name                       | `ghcr.io/mlflow/mlflow`              |          |
| `mlflow.image.tag`                   | MLFlow image tag                        | `v${mlflow.version}`                 |          |
| `postgresql.host`                    | Postgresql host                         |                                      |          |
| `postgresql.user`                    | Postgresql user                         |                                      |          |
| `postgresql.port`                    | Postgresql port                         |                                      |          |
| `postgresql.password`                | Postgresql password                     |                                      |          |
| `postgresql.database`                | Postgresql database                     |                                      |          |
| `mysql.host`                         | Mysql host                              |                                      |          |
| `mysql.user`                         | Mysql user                              |                                      |          |
| `mysql.port`                         | Mysql port                              |                                      |          |
| `mysql.password`                     | Mysql password                          |                                      |          |
| `mysql.database`                     | Mysql database                          |                                      |          |
| `bucket.region`                      | Storage bucket region                   | `us-east-1`                          |          |
| `bucket.endpoint`                    | Storage bucket endpoint                 |                                      |          |
| `bucket.accessKey`                   | Storage access key                      |                                      |   `x`    |
| `bucket.secretKey`                   | Storage secret key                      |                                      |   `x`    |
| `azure.storageAccount.name`          | Storage Account name                    |                                      |          |
| `azure.storageAccount.containerName` | Storage Account name                    |                                      |          |
| `azure.storageAccount.accessKey`     | Storage Account name                    |                                      |          |

## Implementation Details

```text
./
├── base                        # backend for UI and operator for tensorboards
│   ├── deployment.yaml         # deployment manifest
│   ├── kustomization.yaml      # kustomize deployment manifest
│   └── service.yaml            # service manifest
├── hub-component.yaml              # configuration and parameters file of Hub component
├── ingress.yaml.gotemplate         # helm chart template
├── kustomization.yaml.gotemplate   # contains kustomize scr
├── post-undeploy                   # script that is executed after undeploy of the current component
└── pre-deploy                      # script that is executed before deploy of the current component
```

## See Also

* MLFlow [website](https://mlflow.org/)
