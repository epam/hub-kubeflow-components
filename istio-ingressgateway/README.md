# Istio Gateway

Along with creating a service mesh, Istio allows you to manage gateways, which are Envoy proxies running at the edge of the mesh, providing fine-grained control over traffic entering and leaving the mesh.

Current component will use a Helm chart to deploy an Istio Gateway

## Parameters

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `hub.componentName` | Name of the istio ingress gateway | |
| `dns.domain` | Domain name of the kubeflow stack | |
| `component.istio.namespace` | Namespace of the istio | `istio-system` |
| `component.istio.version` | Version of Istio | `1.5.9` |
| `component.istio.ingressGateway.replicas` | Amound of replicas | `1` |
| `component.istio.ingressGateway.serviceType` | Kubernetes service type | `ClusterIP` |
| `component.istio.docker.repository` | Docker repository  | `docker.io/istio` |
| `component.istio.chartDir` | Directory where to place helm chart | `.workdir` |
| `component.istio.chart` | Name of helm tarball file | `istio-${component.istio.version}.tgz` |
| `component.ingress.protocol` | HTTP or HTTPS schema | `http` |
| `component.ingress.class` | Name of ingress class in kubernetes | |
| `component.ingress.host` | Ingress host of kubernetes resource | |
| `component.ingress.maxUploadSize` | Ingress configuration | `1024m` |
| `component.ingress.uploadTimeout` | Ingress configuration | `1800` |
| `component.ingress.readTimeout` | Ingress configuration | `1800` |

## Output parameters

| Name | Description |
| :--- | :---        |
| `component.istio.ingressGateway` | Name of istio gateway |
| `component.ingress.url` | URL of ingress |
| `component.ingress.host` | Hostname of ingress |

## Implementation Specifics

Helm chart downloaded from istio repo: <https://storage.googleapis.com/istio-release/releases/$(ISTIO_VERSION)/charts/>

We use a helm chart `gateways`, which is a dependency of the helm chart `istio`.

Values files has been taken with with precedence to the later:

1. Global values: Taken from `istio/values.yaml` only `global`; rest has been ignored
2. Ingress gateway default values: Taken from `istio/charts/gateways/values.yaml` only `istio-ingressgateway` (renamed to `hub.componentName`); rest has been ignored
3. Component values from: `values.yaml.template`
