# Kubeflow Authn

An [AuthService](https://github.com/arrikto/oidc-authservice) is an HTTP Server that an API Gateway (eg Ambassador, Envoy) asks if an incoming request is authorized.

In the nutshell this component installs an Istio EnvoyFilter that intercepts all HTTP requests to Kubeflow and validates
the user session by checking session cookie:

* If the session is invalid, the user is redirected to the OIDC provider (Dex) for authentication
* If the session is valid, it will add a `kubeflow-userid` header and forward the request to Kubeflow. Kubeflow then
  will use this header to identify the user and lookup it's Kubeflow Profile.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml`file

```yaml
components:
  - name: kubeflow-authn
    source:
      dir: components/kubeflow-authn
      git:
        remote: https://github.com/epam/hub-kubeflow-components.git
        subDir: kubeflow-authn
    depends:
      - dex
      - istio-ingressgateway

```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy kubeflow-authn
```

## Requirements

* Kubernetes
* [Helm](https://helm.sh/docs/intro/install/)
* [Istio](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-discovery)
* [Istio Ingress Gateway](https://github.com/epam/hub-kubeflow-components/tree/develop/istio-ingressgateway)
* Kubernetes Ingress Controller (e.g. [nginx](https://github.com/epam/hub-kubeflow-components/tree/develop/nginx-ingress))
* OIDC Provider (e.g. [Dex](https://github.com/epam/hub-kubeflow-components/tree/develop/dex))

## Parameters

The following component level parameters has been defined for this component:

| Name                             | Description                                                                                               | Default Value                                                                 | Required |
|:---------------------------------|:----------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------|:--------:|
| `ingress.protocol`               | HTTP or HTTPS schema                                                                                      | `http`                                                                        |   `x`    |
| `ingress.hosts`                  | Whitespace separated list of ingress hosts. However first will be used for OIDC auth flow                 |                                                                               |          |
| `oidc.issuer`                    | OIDC auth URL (Dex)                                                                                       |                                                                               |   `x`    |
| `istio.ingressGateway.labels`    | Labels to select Istio ingress gateway and create Envoy Filter                                            |                                                                               |   `x`    |
| `kubernetes.namespace`           | Namespace where envoy filter will be created                                                              | `istio-system`                                                                |   `x`    |
| `storage.volumeSize`             | PV volue size to be allocated for authn replica                                                           | `10Gi`                                                                        |   `x`    |
| `kubeflow.version`               | Kubeflow version                                                                                          | `v1.6.1`                                                                      |          |
| `kubeflow.authn.afterLogin`      | URL to redirect the user to after they login                                                              | `${ingress.protocol}://${ingress.hosts}`                                      |   `x`    |
| `kubeflow.authn.oidcAuthUrl`     | AuthService will initiate an Authorization Code OIDC flow by hitting this URL                             | `${oidc.issuer}/auth`                                                         |   `x`    |
| `kubeflow.authn.oidcProvider`    | Kubeflow OIDC auth URL                                                                                    | `${oidc.issuer}`                                                              |   `x`    |
| `kubeflow.authn.oidcRedirectURI` | AuthService will pass this URL to the OIDC provider when initiating an OIDC flow                          | `${ingress.protocol}://${ingress.hosts}/login/oidc`                           |   `x`    |
| `kubeflow.authn.oidcClientId`    | AuthService will use this Client ID when it needs to contact your OIDC provider and initiate an OIDC flow | `kubeflow-client`                                                             |   `x`    |
| `kubeflow.authn.oidcSecret`      | AuthService will use this Client Secret to authenticate itself against your OIDC provider                 |                                                                               |   `x`    |
| `kubeflow.authn.sessionMaxAge`   | Time in seconds after which user sessions expire                                                          | `86400`                                                                       |          |
| `kustomize.tarball.url`          | URL to the tarball distribution with kustomize scripts                                                    | `https://codeload.github.com/kubeflow/manifests/tar.gz/${kubernetes.version}` |          |
| `kustomize.subpath`              | Path inside tarball for kustomize scripts                                                                 | `common/oidc-authservice/base`                                                |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml                  # Component definition
└── kustomization.yaml.gotemplate       # Kustomize config
```

Deployment follows to the following algorithm:

1. This component has been operated by `kustomize` hub extension.
2. Downloads tarball with base kustomize script and unpacks into the `./kustomize` directory. Fixing missing in
   manifests kustomize variable (namespace)
3. Then start deployment

Current component will deploy a Kubeflow Authn with the Kustomize. It will also expose it as OIDC application. Yet it
will not do any authorization with the OIDC provider. This should be done via stack hook.

### Add OIDC Application to Dex

By design this component works with any OIDC provider. Because Dex is the default SSO for Kubeflow here we will describe
how to add an OIDC application to Dex.

To register Authn with Dex, you need to create a Dex client with the following configuration. Once this is done you need
to update the `oidc.issuer` by running a `Job`

Please note `hub-componetn.yaml` deliberately exposes some parameters required for OIDC application registration
as environment variables available for the stack level hook.

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
            - "--host=dex.dex.svc.cluster.local"
            - "--client-id=${OIDC_CLIENT_ID}"
            - "--client-secret=${OIDC_SECRET}"
            - "--name=${OIDC_CLIENT_ID}"
            - "--redirect-uris=${OIDC_REDIRECT_URI}"
```

### Istio IngressGateway

The component will add an envoy filter to all requests that are coming from the Istio Ingress Gateway. For this reason
you may need to deploy a separate ingress gateway (especially when you have other apps that should not be protected by
Authn).

Link between Ingress Gateway and Authn is done via `istio.ingressGateway.labels` parameter. This parameter is a list of
labels that will be used to match the Istio Ingress Gateway service. Run the command

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

Connectivity between Authn and OIDC provider should be secured with TLS. For places where this is not possible, you can
add a custom CA bundle to the Authn container. This can be done by adding a `Secret` and mounting to the authn STS (yes,
it's a bit hacky, but it works) as post-deploy hook

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

This is the patch that post-deploy hook may apply. It features a secret that contains the bundle `authservice-cacerts`
that has been mounted to the STS and linked as the `CA_BUNDLE` environment variable.

After the patching all pods in STS should be restarted

## See Also

* Kubeflow Authn Design [Article](https://www.arrikto.com/blog/kubeflow/news/kubeflow-authentication-with-istio-dex/)
* Istio documentation on [Envoy Filters](https://istio.io/latest/docs/reference/config/networking/envoy-filter/)
