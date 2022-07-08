# Istio Ingress Gateway

Istio extends Kubernetes to establish a programmable, application-aware network using the powerful Envoy service proxy. Working with both Kubernetes and traditional workloads, Istio brings standard, universal traffic management, telemetry, and security to complex deployments.

Current component will use a Helm chart to deploy an Istio Ingress Gateway

## Parameters

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `hub.componentName` | Name of the istio ingress gateway | |
| `component.istio.namespace` | Namespace of the istio | `istio-system` |
| `component.istio.ingressGateway.type` | Reserved for future variability | `sds` |

## Output parameters

| Name | Description |
| :--- | :---        |
| `component.istio.ingressGateway` | Name of istio gateeway |

## Implementation Specifics

Helm chart downloaded from istio repo: <https://storage.googleapis.com/istio-release/releases/$(ISTIO_VERSION)/charts/>

We use a helm chart `gateways`, which is a dependency of the helm chart `istio`.

Values files has been taken with with precedence to the later:

1. Global values: Taken from `istio/values.yaml` only `global`; rest has been ignored
2. Ingress gateway default values: Taken from `istio/charts/gateways/values.yaml` only `istio-ingressgateway` (renamed to `hub.componentName`); rest has been ignored
3. Component values from: `values.yaml.template`
