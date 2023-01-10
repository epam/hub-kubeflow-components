# Authn HTTP Filter

## Overview of the Authn HTTP Filter

This is a HTTP filter for Istio (Envoy) that validates User session and redirects to dex for authentication (if invalid).

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml                  # Component definition
├── add-oidc-job.yaml.template.         # Template for Kubernetes job to register user
├── kustomization.yaml.template         # Kustomize config
└── oidc.yaml.template                  # Custom resource template for dex integration
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `ingress.protocol` | HTTP or HTTPS schema | `https` |
| `dex.api.endpoint` | Dex API endpoint URL | |
| `dex.issuer` | OIDC auth URL (Dex) | `https://auth.${dns.domain}` |
| `kubeflow.authn.oidcProvider` | Kubeflow OIDC auth URL | `https://kubeflow.${dns.domain}/login/oidc` |
| `kubeflow.authn.oidcSecret` | Hard to guess OIDC secret passphrase between Kubeflow and Dex (recommended: randomly generated string) | |
| `kubeflow.authn.sessionMaxAge` | Max age (in seconds) for user session | `86400` |
| `istio.namespace` | Kubernetes namespace for Istio | `istio-system` |
| `istio.ingressGateway` | Name of Istio ingress gateway service | |

## See Also

* Kubeflow Authn Design [Article](https://www.arrikto.com/blog/kubeflow/news/kubeflow-authentication-with-istio-dex/)
* Istio documentation on [Envoy Filters](https://istio.io/latest/docs/reference/config/networking/envoy-filter/)
