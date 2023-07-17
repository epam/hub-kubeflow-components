# Authn HTTP Filter

## Overview of the Authn HTTP Filter

This is a HTTP filter for Istio (Envoy) that validates User session and redirects to OIDC provider for authentication (if invalid).

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml                  # Component definition
└──  kustomization.yaml.template         # Kustomize config
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `ingress.protocol` | HTTP or HTTPS schema | `https` |
| `oidc.issuer` | OIDC auth URL (Dex) |  |
| `kubeflow.authn.oidcProvider` | Kubeflow OIDC auth URL | `${oidc.issuer}` |
| `kubeflow.authn.oidcSecret` | Hard to guess OIDC secret passphrase between Kubeflow and Dex (recommended: randomly generated string) | |
| `kubeflow.authn.sessionMaxAge` | Max age (in seconds) for user session | `86400` |
| `istio.namespace` | Kubernetes namespace for Istio | `istio-system` |
| `istio.ingressGateway` | Name of Istio ingress gateway service | |

## See Also

* Kubeflow Authn Design [Article](https://www.arrikto.com/blog/kubeflow/news/kubeflow-authentication-with-istio-dex/)
* Istio documentation on [Envoy Filters](https://istio.io/latest/docs/reference/config/networking/envoy-filter/)
