# Kubeflow Authn

This is a HTTP filter for Istio (Envoy) that validates User session and redirects to OIDC provider for authentication (if invalid).

## TLDR
```yaml
  - name: kubeflow-authn
    source:
      dir: components/kubeflow-authn
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-authn
```

## Requirements
- Helm
- Kubernetes
- Kustomize

## Parameters

| Name                           | Description                                                                                            | Default Value    | Required |
|--------------------------------|--------------------------------------------------------------------------------------------------------|------------------|:--------:|
| `ingress.protocol`             | HTTP or HTTPS schema                                                                                   | `https`          |          |
| `oidc.issuer`                  | OIDC auth URL (Dex)                                                                                    |                  |          |
| `kubeflow.authn.oidcProvider`  | Kubeflow OIDC auth URL                                                                                 | `${oidc.issuer}` |          |
| `kubeflow.authn.oidcSecret`    | Hard to guess OIDC secret passphrase between Kubeflow and Dex (recommended: randomly generated string) |                  |          |
| `kubeflow.authn.sessionMaxAge` | Max age (in seconds) for user session                                                                  | `86400`          |          |
| `istio.namespace`              | Kubernetes namespace for Istio                                                                         | `istio-system`   |          |
| `istio.ingressGateway`         | Name of Istio ingress gateway service                                                                  |                  |          |

## Implementation Details
The component has the following directory structure:

```text
./
├── hub-component.yaml                  # Component definition
└──  kustomization.yaml.template        # Kustomize config
```
Deployment follows to the following algorithm:
1. This component has been operated by `kustomize` hub extension.
2. Downloads tarball with base kustomize script and unpacks into the `./kustomize` directory. Fixing missing in manifests kustomize variable (namespace)
3. Then start deployment

## See Also

* Kubeflow Authn Design [Article](https://www.arrikto.com/blog/kubeflow/news/kubeflow-authentication-with-istio-dex/)
* Istio documentation on [Envoy Filters](https://istio.io/latest/docs/reference/config/networking/envoy-filter/)
