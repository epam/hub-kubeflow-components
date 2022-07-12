# Seldon Core

## Overview of the Seldon Core

## Implementation Details

The component has the following directory structure:

```text
./
├── charts                      # Directory contains helm charts archives
├── deploy.sh                   # Script to backup mysql data
├── hub-component.yaml          # Parameters definitions
├── istio-gateway.yaml.template # Parameters definitions
├── undeploy.sh                 # Post deploy script to restore data from backup file if provided
└── values.yaml.template        # Base helm values template
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `dns.domain` | Domain name of the kubeflow stack | |

| `component.seldon.namespace` | | `seldon-system` |
| `component.seldon.version` | | `1.5.0` |
| `executor.resources.cpuLimit` | | `500m` |
| `executor.resources.cpuRequest` | | `500m` |
| `executor.resources.memoryLimit` | | `512Mi` |
| `executor.resources.memoryRequest` | | `512Mi` |
| `manager.cpuLimit` | | `500m` |
| `manager.cpuRequest` | | `100m` |
| `manager.memoryLimit` | | `300Mi` |
| `manager.memoryRequest` | | `200Mi` |
| `storageInitializer.cpuLimit` | | `"1"` |
| `storageInitializer.cpuRequest` | | `100m` |
| `storageInitializer.memoryLimit` | | `1Gi` |
| `storageInitializer.memoryRequest` | | `100Mi` |
| `engine.resources.cpuLimit` | | `500m` |
| `engine.resources.cpuRequest` | | `500m` |
| `engine.resources.memoryLimit` | | `512Mi` |
| `engine.resources.memoryRequest` | | `512Mi` |
| `component.seldon.docker.registry` | | `docker.io` |
| `component.seldon.docker.operator.repository` | | `seldonio/seldon-core-operator` |
| `component.seldon.docker.executor.repository` | | `seldonio/seldon-core-executor` |
| `component.seldon.docker.engine.repository` | | `seldonio/engine` |
| `component.seldon.docker.mlflow.image` | | `seldonio/mlflowserver` |
| `component.seldon.docker.mlflow.tag` | | `"${component.seldon.version}"` |
| `component.seldon.docker.sklearn.image` | | `seldonio/sklearnserver` |
| `component.seldon.docker.sklearn.tag` | | `"${component.seldon.version}"` |
| `component.seldon.docker.kfserving.image` | | `seldonio/mlserver` |
| `component.seldon.docker.kfserving.tag` | | `0.1.1` |
| `component.seldon.docker.tfServingProxy.image` | | `seldonio/tfserving-proxy` |
| `component.seldon.docker.tfServingProxy.tag` | | `"${component.seldon.version}"` |
| `component.seldon.docker.tfServing.image` | | `tensorflow/serving` |
| `component.seldon.docker.tfServing.tag` | | `2.1.0` |
| `component.seldon.docker.xgboost.image` | | `seldonio/xgboostserver` |
| `component.seldon.docker.xgboost.tag` | | `"${component.seldon.version}"` |
| `component.seldon.docker.alibiExplainer.image` | | `seldonio/alibiexplainer` |
| `component.seldon.docker.alibiExplainer.tag` | | `"${component.seldon.version}"` |
| `component.istio.namespace` | | `istio-system` |
| `component.istio.ingressGateway` | | `istio-ingressgateway` |
| `component.ingress.host` | | |

## Outputs

| Name | Description |
| :--- | :---        |
| `component.seldon.istioGateway` | Default istio gateway for seldon deployments |

## See Also
