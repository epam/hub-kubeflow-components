# Istio-ingressgateway

Istiod provides service discovery, configuration and certificate management.
Istiod converts high level routing rules that control traffic behavior into Envoy-specific configurations, and propagates them to the sidecars at runtime.

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
1. At the beginning hubctl need to create an EKS/GKE cluster and other dependency components.
2. Then start deployment
3. `post-deploy` sets up a custom kubectl command with a specific context `$HUB_DOMAIN_NAME`  and namespace `$NAMESPACE`, then conditionally applies an Ingress configuration defined in `ingress.yaml` only if the environment variable `$INGRESS_HOSTS` is not empty and the Ingress resource does not already exist in the specified context and namespace.

## Outputs

| Name                   | Description                           | Default Value          | Required |
|------------------------|---------------------------------------|------------------------|:--------:|
| `istio.ingressGateway` | Name of Istio ingress gateway service | `${hub.componentName}` |          |

## See also

* [Istio](https://istio.io/)
* [Nginx](https://github.com/epam/hub-kubeflow-components/tree/main/nginx-ingress): ingress controller
* [External DNS](https://github.com/kubernetes-sigs/external-dns)
* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)
* [hub cli](https://github.com/agilestacks/hub/wiki)