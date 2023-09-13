# Istio Ingress Gateway

The Istio Ingress Gateway is an Envoy proxy deployed in a Kubernetes cluster that allows access to services running in
the cluster from the outside. The Ingressgateway is configured using Istio's Gateway and VirtualService resources.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml`file

```yaml
components:
  - name: istio-ingressgateway
    source:
      dir: components/istio-ingressgateway
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: istio-ingressgateway
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c istio-ingressgateway
```

## Requirements

- [Helm](https://helm.sh/docs/intro/install/)
- Kubernetes
- [Istio Discovery](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
- Optional: Kubernetes Ingress Controller (
  e.g. [nginx](https://github.com/epam/hub-kubeflow-components/tree/develop/nginx-ingress))

## Parameters

This component consumes following parameters

| Name                     | Description                                | Default Value                                              | Required |
|--------------------------|--------------------------------------------|------------------------------------------------------------|:--------:|
| `ingress.protocol`       | Ingress traffic protocol (schema)          | `http`                                                     |          |
| `ingress.class`          | Name of ingress class in kubernetes        |                                                            |          |
| `ingress.hosts`          | Whitespace separated list of ingress hosts |                                                            |          |
| `kubernetes.namespace`   | Kubernetes namespace                       | `istio-system`                                             |          |
| `kubernetes.replicas`    | Amount of replicas                         | `1`                                                        |          |
| `kubernetes.serviceType` | Kubernetes types of services               | `ClusterIP`                                                |          |
| `helm.chart`             | Helm chart name                            | `gateway`                                                  |          |
| `helm.repo`              | Helm chart repository URL                  | [URL](https://istio-release.storage.googleapis.com/charts) |          |
| `helm.version`           | Helm chart version                         | `1.15.0`                                                   |          |

### Outputs

This component produces following outputs

| Name                          | Description                                                                           | Value                  |
|-------------------------------|---------------------------------------------------------------------------------------|------------------------|
| `istio.ingressGateway.labels` | Forward `kubernetes.labels` to avoid possible `kubeflow.labels` used by the components | `${kubernetes.labels}` |

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
2. `post-deploy` sets up a custom kubectl command with a specific context `$HUB_DOMAIN_NAME` and namespace `$NAMESPACE`,
   then conditionally applies an Ingress configuration defined in `ingress.yaml` only if the environment
   variable `$INGRESS_HOSTS` is not empty and the Ingress resource does not already exist in the specified context and
   namespace.

### Special Note for Labels

Istio CRD `Gateway` is using labels to discover service of Ingress Gateway. These labels can be defined by the user
via `kubernetes.labels` parameter.

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

If `kubernetes.serviceType` is set to `LoadBalancer` (or maybe `NodePort`) then the Ingress Gateway Service will be
exposed as LoadBalancer.

By default, however `kubernetes.serviceType` is set to `ClusterIP`. This can be used for internal traffic or exposed on
behalf of the Ingress resource.

### Kubernetes Parameters Ambiguity

This component is using `kubernetes.labels` values of this parameter however may be used by another component to
discover ingress gateway. CRD `Gateway` for instance are using labels selector. This may conflict
with `kubernets.labels` of the component itself. To avoid this conflict the `kubernetes.labels` are forwarded to the
output of the component as `istio.ingressGateway.labels` parameter. This parameter can be used by other components to
discover ingress gateway.

## See Also

* [Istio Discovery](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
* [Istio Base](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
* [Nginx](https://github.com/epam/hub-kubeflow-components/tree/main/nginx-ingress): ingress controller

