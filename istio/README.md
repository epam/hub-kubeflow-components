# Istio

Istio extends Kubernetes to establish a programmable, application-aware network using the powerful Envoy service proxy. Working with both Kubernetes and traditional workloads, Istio brings standard, universal traffic management, telemetry, and security to complex deployments.

## Parameters

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `hub.componentName` | Name of the istio ingress gateway | |
| `dns.domain` | Domain name of the kubeflow stack | |
| `component.istio.namespace` | Kubernetes namespace where istio is deloyed | `istio-system` |
| `component.istio.chart.name` | Name of helm chart | `istio` |
| `component.istio.version` | Version of Istio | `1.5.9` |

## Output parameters

| Name | Description |
| :--- | :---        |
| `component.istio.namespace` | Name of istio gateeway |

## Implementation Specifics

Helm chart downloaded from istio repo: <https://storage.googleapis.com/istio-release/releases/$(ISTIO_VERSION)/charts/>
