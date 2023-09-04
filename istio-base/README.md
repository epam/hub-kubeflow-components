# Istio-base

Istio is an open-source platform that provides a set of tools for managing, securing, and monitoring microservices-based applications in a containerized environment, such as Kubernetes. Istio-base is the foundational components and functionality of the Istio service mesh.

## TLDR

```yaml
  - name: istio-base
    source:
      dir: components/istio-base
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: istio-base
```

## Requirements

- Helm
- Kubernetes

## Parameters

| Name                   | Description               | Default Value                                         | Required |
|------------------------|---------------------------|-------------------------------------------------------|:--------:|
| `kubernetes.namespace` | Kubernetes namespace      | `istio-system`                                        |          |
| `helm.repo`            | Helm chart repository URL | <https://istio-release.storage.googleapis.com/charts> |          |
| `helm.chart`           | Helm chart name           | `base`                                                |          |
| `helm.version`         | Helm chart version        | `1.15.0`                                              |          |


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

* [hub cli](https://github.com/agilestacks/hub/wiki)
* [External DNS](https://github.com/kubernetes-sigs/external-dns)
* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)