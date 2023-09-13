# Istio-discovery

Istiod provides service discovery, configuration and certificate management. Istiod converts high level routing rules that control traffic behavior into Envoy-specific configurations, and propagates them to the sidecars at runtime.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml`file

```yaml
components:
  - name: istio-discovery
    source:
      dir: components/istio-discovery
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: istio-discovery
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c istio-discovery
```

## Requirements

- [Helm](https://helm.sh/docs/intro/install/)
- Kubernetes

## Parameters

| Name                   | Description                | Default Value                                         | Required |
|------------------------|----------------------------|-------------------------------------------------------|:--------:|
| `kubernetes.namespace` | Kubernetes namespace       | `istio-system`                                        |          |
| `helm.chart`           | Helm chart name            | `istiod`                                              |          |
| `helm.repo`            | Helm chart repository URL  | <https://istio-release.storage.googleapis.com/charts> |          |
| `helm.version`         | Helm chart version         | `1.15.0`                                              |          |
| `helm.valuesFile`      | File for helm chart values | `values.yaml`                                         |          |

## Implementation Details

The component has the following directory structure:
```text
./
├── hub-component.yaml    # manifest file of the component with configuration and parameters
└── values.yaml.template  # hubctl template of helm chart values
```

Deployment follows to the following algorithm:
1. At the beginning hubctl need to create a Kubernetes cluster and other dependency components.
2. Then start deployment

## See also

* [Istio Base](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
* [Istio Ingressgateway](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-ingressgateway)
* [Nginx](https://github.com/epam/hub-kubeflow-components/tree/main/nginx-ingress): ingress controller
* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)
