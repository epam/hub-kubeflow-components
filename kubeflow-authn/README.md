# Kubeflow Authn

This is a rewrite for [ambassador-auth-oidc](https://github.com/ajmyyra/ambassador-auth-oidc) to serve authentication requests for Kubeflow.

In the nutshel this component installs an Istio EnvoyFilter that intercepts all HTTP requests to Kubeflow and validates the user session by checking session cookie:

* If the session is invalid, the user is redirected to the OIDC provider (Dex) for authentication
* If the session is valid, it will add a `kubeflow-userid` header and forward the request to Kubeflow. Kubeflow then will use this header to identify the user and lookup it's Kubeflow Profile.

## TL;DR

To deploy current component add the following stanza to your `hub.yaml`

```yaml
components:
- name: kubeflow-authn
  source:
    dir: components/kubeflow-authn
    git:
      remote: https://github.com/epam/kubeflow-components.git
      subDir: kubeflow-authn
  depends:
  - dex
  - istio-ingressgateway

```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
hubctl stack deploy -c "kubeflow-authn"
```

## Requirements

* Kubenretes
* [Helm](https://helm.sh/docs/intro/install/)
* [Istio](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
* [Istio Ingress Gateway](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-ingressgateway)
* Kubenretes Ingress Controller (e.g. [nginx](https://github.com/epam/hub-kubeflow-components/tree/develop/nginx-ingress))
* OIDC Provider (e.g. [Dex](https://github.com/epam/hub-kubeflow-components/tree/develop/dex))

## Parameters

The following component level parameters has been defined for this component:

| Name      | Description | Default Value | Required
| --------- | ---------   | ---------     | :---: |
| `ingress.protocol` | HTTP or HTTPS schema | `https` | `x`
| `ingress.hosts` | Whitespace separated list of ingress hosts. However first will be used for OIDC auth flow | |
| `oidc.issuer` | OIDC auth URL (Dex) |  | `x`
| `kubeflow.authn.oidcProvider` | Kubeflow OIDC auth URL | `${oidc.issuer}` | `x`
| `kubeflow.authn.oidcSecret` | Hard to guess OIDC secret passphrase between Kubeflow and Dex (recommended: randomly generated string) | | `x`
| `kubeflow.authn.sessionMaxAge` | Max age (in seconds) for user session | `86400` |
| `kubernetes.namespace` | Namespace where envoy filter will be created| `istio-system` | `x`
| `kubeflow.version` | Kubeflow version | `v1.6.1` |
| `kubeflow.authn.oidcProvider` | TBD |  |
| `kubeflow.authn.oidcAuthUrl` | TBD |  | `x`
| `kubeflow.authn.oidcRedirectURI` | TBD |  | `x`
| `kubeflow.authn.afterLogin` | TBD |  | `x`
| `kubeflow.authn.oidcClientId` | TBD |  `kubeflow-client` | `x`
| `kubeflow.authn.sessionMaxAge` | Auth session max age |  `86400` | `x`
| `storage.volumeSize` | PV volue size to be allocated for authn replica |  `10Gi` | `x`


## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml                  # Component definition
└── kustomization.yaml.gotemplate       # Kustomize config
```

Deployment follows to the following algorithm:

1. This component has been operated by `kustomize` hub extension.
2. Downloads tarball with base kustomize script and unpacks into the `./kustomize` directory. Fixing missing in manifests kustomize variable (namespace)
3. Then start deployment

Current component will deploy a Kubeflow Authn with the Kustomize. It will also expose it as OIDC application. Yet it will not do any authorization with the OIDC provider. This should be done via stack hook.

### Add OIDC Application to Dex

By design this component works with any OIDC provider. Because Dex is the default SSO for Kubeflow here we will describe how to add an OIDC application to Dex.

To register Authn with Dex, you need to create a Dex client with the following configuration. Once this is done you need to update the `oidc.issuer` by running a `Job`

Please note `hub-componetn.yaml` deliberately exposes some of the paramters required for OIDC application registration as environment variables avalable for the stack level hook.

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  generateName: kubeflow-oidc-
spec:
  ttlSecondsAfterFinished: 120
  backoffLimit: 0
  template:
    spec:
      restartPolicy: Never
      containers:
        - image: ghcr.io/epam/dexctl:5d481d0
          name: main
          args:
            - create
            - oidc
            - "--skip-exit-code"
            - "--host=dex.example.com"
            - "--client-id=${OIDC_CLIENT_ID}"
            - "--client-secret=${OIDC_SECRET}"
            - "--name=${OIDC_CLIENT_ID}"
            - "--redirect-uris=${OIDC_REDIRECT_URI}"
```

### Istio IngressGateway

The component will add an envoy filter to all requests that are coming from the Istio Ingress Gateway. For this reasons you may need to deploy a separate ingress gateway (a specially when you have other apps that should not be protected by Authn).

Link between Ingress Gateway and Authn is done via `istio.ingressGateway.labels` parameter. This parameter is a list of labels that will be used to match the Istio Ingress Gateway service. Run the command

To check labels run the command:

```bash
kubectl -n istio-system get svc "istio-ingressgateway" -o jsonpath='{.metadata.labels}'
# app=istio-ingressgateway istio=ingressgateway
```

These labels should be set as `istio.ingressGateway.labels` parameter.

```yaml
parameters:
- name: istio.ingressGateway.labels
  component: kubeflow-authn
  value: >- 
    app=istio-ingressgateway
    istio=ingressgateway
```

### Add Custom CA Bundle

> OPTIONAL

Connectivity between Authn and OIDC provider should be secured with TLS. For places where this is not possible, you can add a custom CA bundle to the Authn container. This can be done by adding a `Secret` and mounting to the authn STS (yes, it's a bit hacky, but it works) as post-deploy hook

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: authservice
spec:
  template:
    spec:
      volumes:
      - name: cacerts
        secret:
          secretName: authservice-cacerts
          optional: false
      containers:
      - name: authservice
        env:
        - name: CA_BUNDLE
          value: /etc/ssl/certs/cacerts.pem
        volumeMounts:
        - name: cacerts
          mountPath: /etc/ssl/certs
```

This is the patch that post-deploy hook may appliy. It features a secret that contains the bundle `authservice-cacerts` that has been mounted to the STS and linked as the `CA_BUNDLE` environment variable.

After the patching all pods in STS should be restarted

## See Also

* Kubeflow Authn Design [Article](https://www.arrikto.com/blog/kubeflow/news/kubeflow-authentication-with-istio-dex/)
* Istio documentation on [Envoy Filters](https://istio.io/latest/docs/reference/config/networking/envoy-filter/)
