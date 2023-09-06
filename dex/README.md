# DEX

Dex is an identity service that uses [OpenID Connect](https://openid.net/connect/) to drive authentication for other apps.

Dex acts as a portal to other identity providers through [“connectors.”](https://dexidp.io/docs/connectors/) This lets Dex defer authentication to LDAP servers, SAML providers, or established identity providers like GitHub, Google, and Active Directory. Clients write their authentication logic once to talk to Dex, then Dex handles the protocols for a given backend.

## TL;DR

```yaml
- name: dex
  source:
    dir: components/dex
    git:
      remote: https://github.com/epam/hub-kubeflow-components.git
      subDir: dex
```

To initiate the deployment, run the following commands:
```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c dex
```

## Requirements

- [Helm](https://helm.sh/docs/intro/install/)
- Kubernetes

## Parameters

The following component level parameters can be set in `hub-component.yaml`:

| Name                                      | Description                                                       | Default Value                            | Required |
|-------------------------------------------|-------------------------------------------------------------------|------------------------------------------|:--------:|
| `dns.domain`                              | Domain name of the kubeflow stack                                 |                                          |          |
| `ingress.protocol`                        | HTTP or HTTPS schema                                              | `https`                                  |          |
| `ingress.class`                           | Name of ingress class in kubernetes                               |                                          |          |
| `ingress.ssoUrlPrefix`                    | Url prefix for protected applications                             | `dex`                                    |          |
| `ingress.hosts`                           | Hostname of the kubeflow stack                                    |                                          |          |
| `kubernetes.namespace`                    | Name of kubernetes namespace where Dex will be deployed           | `kube-system`                            |          |
| `dex.issuer`                              | Url of Dex issuer                                                 | `${ingress.protocol}://${ingress.hosts}` |          |
| `dex.image.repo`                          | Dex docker image                                                  | `ghcr.io/dexidp/dex`                     |          |
| `dex.image.tag`                           | Dex docker image                                                  | `v2.32.0`                                |          |
| `dex.passwordDb.email`                    | Static password DB user email                                     |                                          |    x     |
| `dex.passwordDb.password`                 | Static password DB user password                                  |                                          |    x     |
| `dex.connectors.ldap.host`                | Host and optional port of the LDAP server in the form "host:port" |                                          |          |
| `dex.connectors.ldap.dn`                  | The DN for an application service account                         |                                          |          |
| `dex.connectors.ldap.usernamePrompt`      | The attribute to display in the provided password prompt          | `Username`                               |          |
| `dex.connectors.ldap.password`            | The password for an application service account                   |                                          |          |
| `dex.connectors.ldap.search.dn`           | User search. BaseDN to start the search from                      |                                          |          |
| `dex.connectors.ldap.search.usernameAttr` | Username attribute used for comparing user entries                | `uid`                                    |          |
| `dex.connectors.ldap.search.filter`       | Optional filter to apply when searching the directory             | `(objectClass=user)`                     |          |
| `dex.connectors.ldap.search.idAttr`       | String representation of the user                                 | `uid`                                    |          |
| `dex.connectors.ldap.groupSearch.dn`      | Group search. BaseDN to start the search from                     | `${dex.ldap.search.dn}`                  |          |
| `dex.connectors.okta.issuer`              | OKTA issuer URL                                                   |                                          |          |
| `dex.connectors.okta.clientId`            | OKTA Oauth2 client id                                             |                                          |          |
| `dex.connectors.okta.clientSecret`        | OKTA Oauth2 client secret                                         |                                          |          |
| `helm.repo`                               | Helm repo of Dex                                                  | `https://charts.dexidp.io`               |          |
| `helm.chart`                              | Name of Dex helm chart                                            | `dex`                                    |          |
| `helm.version`                            | Version of Dex helm chart                                         | `0.13.0`                                 |          |

## Implementation Details

The component has the following directory structure:
```text
./
├── hub-component.yaml      # Component definition file
└── values.yaml.gotemplate  # Helm chart values file
```

Deployment follows to the following algorithm:
1. Dependency components need to be deployed beforehand.
2. To do this with running Dex and without restarting or redeploying Dex you need to use Dex API. 
3. To communicate with Dex API we have created a command line tool - [dexctl](https://github.com/agilestacks/dexctl). 
4. To use it you need to create a Kubernetes Job resource which will execute call to Dex API. Job should use `gcr.io/superhub/dexctl:latest` Docker image.

## Outputs

| Name               | Description          | Default Value                                                    | Required |
|--------------------|----------------------|------------------------------------------------------------------|:--------:|
| `dex.api.endpoint` | Dex API endpoint URL | `${hub.componentName}.${kubernetes.namespace}.svc.cluster.local` |          |
| `dex.issuer`       | Dex issuer URL       |                                                                  |          |

## See also

* [DEX](https://dexidp.io/)
* [GCS Bucket Component](https://github.com/epam/hub-google-components/tree/develop/gsbucket)