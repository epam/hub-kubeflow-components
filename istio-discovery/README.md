# Istio-discovery

Istiod provides service discovery, configuration and certificate management. Istiod converts high level routing rules that control traffic behavior into Envoy-specific configurations, and propagates them to the sidecars at runtime.

## TLDR

```yaml
  - name: istio-discovery
    source:
      dir: components/istio-discovery
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: istio-discovery
```

## Requirements

- Helm
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

* [Istio](https://istio.io/)
* [External DNS](https://github.com/kubernetes-sigs/external-dns)
* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)
* [hub cli](https://github.com/agilestacks/hub/wiki)