# Istio-ingressgateway

The Istio Ingressgateway is an Envoy proxy deployed in a Kubernetes cluster that allows access to services running in the cluster from the outside. The Ingressgateway is configured using Istio's Gateway and VirtualService resources.

## TLDR

```yaml
  - name: istio-ingressgateway
    source:
      dir: components/istio-ingressgateway
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: istio-ingressgateway
```

## Requirements

- Helm
- Kubernetes

## Parameters

| Name                             | Description                                           | Default Value                                         | Required |
|----------------------------------|-------------------------------------------------------|-------------------------------------------------------|:--------:|
| `ingress.protocol`               | Ingress traffic protocol (schema)                     | `http`                                                |          |
| `ingress.class`                  | Name of ingress class in kubernetes                   |                                                       |          |
| `ingress.hosts`                  | List of ingress hosts (Note: only first will be used) |                                                       |          |
| `nginx.maxUploadSize`            | Limit File Upload Size in Nginx                       | `1024m`                                               |          |
| `nginx.uploadTimeout`            | Nginx proxy timeout while uploading big files         | `1800`                                                |          |
| `nginx.readTimeout`              | Nginx request timeout                                 | `1800`                                                |          |
| `kubernetes.namespace`           | Kubernetes namespace                                  | `istio-system`                                        |          |
| `kubernetes.replicas`            | Amount of replicas                                    | `1`                                                   |          |
| `kubernetes.cluster.serviceType` | Kubernetes types of services                          | `ClusterIP`                                           |          |
| `helm.chart`                     | Helm chart name                                       | `gateway`                                              |          |
| `helm.repo`                      | Helm chart repository URL                             | <ttps://istio-release.storage.googleapis.com/charts> |          |
| `helm.version`                   | Helm chart version                                    | `1.15.0`                                              |          |

## Implementation Details

The component has the following directory structure:
```text
./
├── hub-component.yaml          # manifest file of the component with configuration and parameters
├── ingress.yaml.gotemplate     # istio ingress definition template
├── post-deploy                 # script that is executed after deploy of the current component
├── post-undeploy               # script that is executed after undeploy of the current component
└── values.yaml.template        # hubctl template of helm chart values
```

Deployment follows to the following algorithm:

1. Hubctl will use a helm chart from parameters `helm.repo` and `helm.chart` to deploy the Istio Ingressgateway.
2. `post-deploy` sets up a custom kubectl command with a specific context `$HUB_DOMAIN_NAME` and namespace `$NAMESPACE`, then conditionally applies an Ingress configuration defined in `ingress.yaml` only if the environment variable `$INGRESS_HOSTS` is not empty and the Ingress resource does not already exist in the specified context and namespace.

## Outputs

| Name                   | Description                           | Default Value          | Required |
|------------------------|---------------------------------------|------------------------|:--------:|
| `istio.ingressGateway` | Name of Istio ingress gateway service | `${hub.componentName}` |          |

### Special Case for Labels

Istio CRD `Gateway` is using labels to discover service of Ingress Gateway. These labels can be defined by the user via `kubernetes.labels` parameter.

```yaml
parameters:
- name: kubernetes.labels
  value:
    app: mygateway
```

Then the `Gateway` CRD will be created with the following selector

```yaml
selector:
  matchLabels:
    app: mygateway
```

### Expose as Ingress

If `ingress.hosts` is defined then the Ingress resource will be created infront of the Ingress Gateway Service

```yaml
parameters:
- name: ingress.hosts
  value: |
    myhost.example.com
    myhost2.example.com
```

In this case ingress with two hosts will be crated

### Expose as Service

If `kubernetes.serviceType` is set to `LoadBalancer` (or maybe `NodePort`) then the Ingress Gateway Service will be exposed as LoadBalancer.

By default however `kubernetes.serviceType` is set to `ClusterIP`. This can be used for internal traffic or exposed on behalf of the Ingress resource.

## See Aslo

- [Istio Discovery](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
- [Istio Base](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
- [Istio](https://istio.io/)
- [Nginx](https://github.com/epam/hub-kubeflow-components/tree/main/nginx-ingress): ingress controller
