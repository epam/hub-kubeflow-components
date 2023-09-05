# Seldon Core

Seldon provides a set of tools for deploying machine learning models at scale.
Deploy machine learning models in the cloud or on-premise.
Get metrics and ensure proper governance and compliance for your running machine learning models

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml
components:
  - name: seldon-core
    source:
      dir: components/seldon-core
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: seldon-core
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting Name of the existing Kubernetes storage class: local-path
# * Setting ingress class: traefik
# * Setting parameter dex.passwordDb.password: <random>
# * Setting executor: local
hubctl stack deploy -c seldon-core
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name                   | Description                                           | Default Value                                                  | Required 
|:-----------------------|:------------------------------------------------------|:---------------------------------------------------------------|:--------:|
| `kubernetes.namespace` | Kubernetes namespace for this component               | `kubeflow`                                                     |          |
| `seldon.version`       |                                                       | `1.14.1`                                                       |
| `helm.repo`            | Helm chart repository URL                             | `https://argoproj.github.io/argo-helm`                         |          |
| `helm.chart`           | Helm chart name                                       | `argo-workflows`                                               |          |
| `helm.version`         | Helm version                                          | `v1.11.1`                                                      |          |
| `helm.valuesFile`      | Helm base values file                                 | `values.yaml`                                                  |          |         |
| `ingress.hosts`        | List of ingress hosts (Note: only first will be used) |                                                                |          |
| `ingress.protocol`     | Ingress traffic protocol (schema)                     | `http`                                                         |          |
| `istio.namespace`      |                                                       | `istio-system`                                                 |
| `istio.ingressGateway` |                                                       | `istio-ingressgateway`                                         |
| `istio.gateway.name`   |                                                       | `${hub.componentName}`                                         |
| `istio.gateway.hosts`  |                                                       | `${istio.ingressGateway}.${istio.namespace}.svc.cluster.local` |

## Implementation Details

The component has the following directory structure:

```text
./
├── bin                             # directory contains additional component hooks
│   └── self-signed-ca.sh           # hook for generating self-signed certificates
├── hub-component.yaml              # configuration and parameters file of Hub component
├── istio-gateway.yaml.template     # Parameters definitions
├── post-undeploy                   # script that is executed after undeploy of the current component
├── pre-deploy                      # script that is executed before deploy of the current component
├── seldon-edit.yaml.template       # cluster role template
└── values.yaml.template            # helm values template
```

## See Also

- Seldon official [website](https://www.seldon.io/)