# Istio-discovery

Istiod provides service discovery, configuration and certificate management.
It converts high level routing rules that control traffic behavior into Envoy-specific configurations, and propagates them to the sidecars at runtime.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml`file

```yaml
components:
  - name: istio-discovery
    source:
      dir: components/istio-discovery
      git:
        remote: https://github.com/epam/hub-kubeflow-components.git
        subDir: istio-discovery
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy istio-discovery
```

## Requirements

* [Helm]
* [Kubernetes]

## Parameters

| Name                                     | Description                                     | Default Value                |
|:-----------------------------------------|:------------------------------------------------|:-----------------------------|
| `kubernetes.namespace`                   | Kubernetes namespace                            | `istio-system`               |
| `istio.version`                          | Istio version                                   | `1.16.7`                     |
| `istio.image.repository`                 | Istio images repository                         | `docker.io/istio`            |
| `istio.telemetry.enabled`                | Enable Istio telemetry                          | `true`                       |
| `istio.pilot.autoscaling.enabled`        | Enable Istio autoscaling                        | `true`                       |
| `istio.pilot.autoscaling.minReplicas`    | Istio autoscaling minimum number of replicas    | `1`                          |
| `istio.pilot.autoscaling.maxReplicas`    | Istio autoscaling maximum number of replicas    | `5`                          |
| `istio.pilot.autoscaling.cpuUtilization` | Istio autoscaling CPU utilization in percentage | `80`                         |
| `istio.pilot.limits`                     | Istio pilot resources limits                    | `cpu: 200m`, `memory: 256Mi` |
| `istio.pilot.requests`                   | Istio pilot resources requests                  | `cpu: 100m`, `memory: 128Mi` |
| `istio.sidecar.limits`                   | Istio sidecar container resources limits        | `cpu: 200m`, `memory: 256Mi` |
| `istio.sidecar.requests`                 | Istio sidecar container resources requests      | `cpu: 100m`, `memory: 128Mi` |
| `helm.chart`                             | Helm chart name                                 | `istiod`                     |
| `helm.repo`                              | Helm chart repository URL                       | [istio helm repo]            |

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml        # manifest file of the component with configuration and parameters
└── values.yaml.gotemplate    # hubctl template of helm chart values
```

Deployment follows to the following algorithm:

1. At the beginning hubctl need to create a Kubernetes cluster and other dependency components.
2. Then start deployment

## See also

* [Istio Base](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
* [Istio Ingressgateway](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-ingressgateway)
* [Nginx](https://github.com/epam/hub-kubeflow-components/tree/main/nginx-ingress): ingress controller
* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)

[Helm]: https://helm.sh/docs/intro/install/
[Kubernetes]: https://kubernetes.io/
[istio helm repo]: https://istio-release.storage.googleapis.com/charts
