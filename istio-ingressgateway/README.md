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

This compnent consumes following parameters

| Name      | Description | Default Value | Required
| --------- | ---------   | ---------     | :---: |
| `kubernetes.namespace` | Should be the same as istio  | `istio-system` | `x`
| `kubernetes.replicas` | ReplicaCount definition  | `1` | `x`
| `kubernetes.serviceType` | Defines kubernetes service type to expose ingressgateway | `ClusterIP` | `x`
| `kubernetes.labels` | key-value pairs separated by `=` and ` ` to define ingress gateway service selector | `x`
| `kubernetes.requests` | similar to `kubernetes.labels` request quota definition | see component | `x`
| `kubernetes.limits` | similar to `kubernetes.labels` request limit quota definition | see component | `x`
| `istio.version` | Version of istio control plane | `v1.15.0` | `x`
| `ingress.hosts` | If defined then Ingress resource will be created infront the Kubernetes Service |  | 
| `ingress.class` | Ingress class reference |  | 
| `ingress.protocol` | Controls `tls` configuration for ingress (when `https`) |  | 
| `nginx.*` | Deprecated, these parameters should go to stack  level hook |  | 
| `helm.repo` | Reference to the helm chart repository | [link](https://istio-release.storage.googleapis.com/charts) | `x`
| `helm.name` | Helm chart name to use | `gateway` | `x`

### Outputs

| Name      | Description | Value 
| --------- | ---------   | --------- 
| `istio.ingressGateway.labels` | Forward `kubernetes.labels` to avoid possible `kubeflow.labels` used by the compnents | `${kubernetes.labels}`

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
  value: >-
    myhost.example.com
    myhost2.example.com
```

In this case ingress with two hosts will be crated

### Expose as Service

If `kubernetes.serviceType` is set to `LoadBalancer` (or maybe `NodePort`) then the Ingress Gateway Service will be exposed as LoadBalancer.

By default however `kubernetes.serviceType` is set to `ClusterIP`. This can be used for internal traffic or exposed on behalf of the Ingress resource.

### Kubernetes Parameters Ambiguidy

This component is using `kubernetes.labels` values of this parameter however may be used by another component to discover ingress gateway. CRD `Gateway` for instance are using labels selector. This may conflict with `kubernets.labels` of the component itself. To avoid this conflict the `kubernetes.labels` are forwarded to the output of the component as `istio.ingressGateway.labels` parameter. This parameter can be used by other components to discover ingress gateway.

## See Aslo

- [Istio Discovery](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
- [Istio Base](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
- [Istio](https://istio.io/)
- [Nginx](https://github.com/epam/hub-kubeflow-components/tree/main/nginx-ingress): ingress controller
