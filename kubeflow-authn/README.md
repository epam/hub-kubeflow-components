# Kubeflow Authn HTTP Filter

This is a HTTP filter for Istio (Envoy) that validates User session and redirects to dex for authentication (if invalid).

## Implementation Details & Parameters

The component has the following directory structure:

```text
./
├── patches                             # Kustomize patches
├── authn-envoy-filter.json.template    # HTTP filter configuration
├── hub-component.yaml                  # Component definition
├── intel-cabundle-sts.yaml.template    # CA bundle defined here
├── kustomization.yaml.template         # Kustomize config
├── oidc.yaml.template                  # Integration with Dex
├── pre-deploy                          # Script to download tarball from kubeflow distribution website
└── pre-undeploy -> pre-deploy
```

The component uses an offical Kubeflow distribution Kustomize [scripts]("https://github.com/kubeflow/manifests/") as a and applies patches and additiona resources described in [kustomize.yaml](kustomize.yaml.template) file.

Where [pre-deploy](pre-deploy) script has been responsible for download tarball from Kubeflow official distribution website.

The following component level parameters has been defined `hub-component.yaml`:

### Dex parameters

Parameters to configure dex integration

| Name      | Description | Default Value
| --------- | ---------   | ---------
| `component.ingress.protocol` | HTTP or HTTPS schema | `https`
| `component.ingress.protocol` | HTTP or HTTPS schema | `https`
| `component.dex.issuer` | OIDC auth URL (Dex) | `http://auth.${domain.name}`
| `component.kubeflow.authn.oidcProvider` | Kubeflow OIDC auth URL | `https://kubeflow.${dns.domain}/login/oidc`
| `component.kubeflow.authn.oidcSecret` | Hard to guess OIDC secret passphrase between Kubeflow and Dex (recommended: randomly generated string) |
| `component.kubeflow.authn.caSecret` | If not empty then name of Kubernetes secret with where CA bundle can be found. If empty value, then CA bundle will be ignored |
| `component.kubeflow.authn.sessionMaxAge` | Max age (in seconds) for user session | `86400`

### Istio parameters (HTTP filter)

| `component.istio.namespace` | Kubernetes namespace for Istio | `isttio-system`
| `component.istio.ingressGateway` | Name of Istio ingress gateway service |

## See Also

* Kubeflow Authn Design [Article](https://www.arrikto.com/blog/kubeflow/news/kubeflow-authentication-with-istio-dex/)
* Istio documentation on [Envoy Filters](https://istio.io/latest/docs/reference/config/networking/envoy-filter/)
