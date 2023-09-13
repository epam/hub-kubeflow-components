# Istio-base

Istio is an open-source platform that provides a set of tools for managing, securing, and monitoring microservices-based applications in a containerized environment, such as Kubernetes. Istio-base is the foundational components and functionality of the Istio service mesh.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml`file

```yaml
components:
  - name: istio-base
    source:
      dir: components/istio-base
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: istio-base
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c istio-base
```

## Requirements

- [Helm](https://helm.sh/docs/intro/install/)
- Kubernetes

## Parameters

| Name                   | Description               | Default Value                                               | Required |
|------------------------|---------------------------|-------------------------------------------------------------|:--------:|
| `kubernetes.namespace` | Kubernetes namespace      | `istio-system`                                              |          |
| `helm.repo`            | Helm chart repository URL | [repo](https://istio-release.storage.googleapis.com/charts) |          |
| `helm.chart`           | Helm chart name           | `base`                                                      |          |
| `helm.version`         | Helm chart version        | `1.15.0`                                                    |          |


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

* [Istio Discovery](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
* [Istio Base](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
* [Nginx](https://github.com/epam/hub-kubeflow-components/tree/main/nginx-ingress): ingress controller
* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)

