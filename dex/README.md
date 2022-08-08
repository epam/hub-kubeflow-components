# DEX

## Overview of Argo Workflows

Dex is an identity service that uses [OpenID Connect](https://openid.net/connect/) to drive authentication for other apps.

Dex acts as a portal to other identity providers through [“connectors.”](https://dexidp.io/docs/connectors/) This lets Dex defer authentication to LDAP servers, SAML providers, or established identity providers like GitHub, Google, and Active Directory. Clients write their authentication logic once to talk to Dex, then Dex handles the protocols for a given backend.

This component is based on official [Dex Helm chart](https://github.com/dexidp/helm-charts)

## Implementation Details

The Dex Component has the following directory structure:

```text
./
├── hub-component.yaml      # Component definition file
└── values.yaml.template    # Helm chart values file
```

## Parameters

The following component level parameters can be set in `hub-component.yaml`:

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `dns.domain` | Domain name of the kubeflow stack | |
| `component.ingress.protocol` | HTTP or HTTPS schema | `https` |
| `component.ingress.class` | Name of ingress class in kubernetes | |
| `component.ingress.ssoUrlPrefix` | Url prefix for protected applications | `dex` |
| `dex.name` | Name of Dex kubernetes resources | `dex` |
| `dex.namespace` | Name of kubernetes namespace where Dex will be deployed | `kube-system` |
| `dex.issuerFqdn` | Url of Dex issuer | `auth.${dns.domain}` |
| `dex.image.repo` | Dex docker image | `ghcr.io/dexidp/dex` |
| `dex.image.tag` | Dex docker image | `v2.32.0` |
| `dex.helm.repo` | Helm repo of Dex | `https://charts.dexidp.io` |
| `dex.helm.chart` | Name of Dex helm chart | `dex` |
| `dex.helm.version` | Version of Dex helm chart | `0.9.0` |
| `dex.passwordDb.email` | Static password DB user email | |
| `dex.passwordDb.password` | Static password DB user password | |
| `dex.connectors.ldap.host` | Host and optional port of the LDAP server in the form "host:port" | |
| `dex.connectors.ldap.dn` | The DN for an application service account | |
| `dex.connectors.ldap.usernamePrompt` | The attribute to display in the provided password prompt | `Username` |
| `dex.connectors.ldap.password` | The password for an application service account | |
| `dex.connectors.ldap.search.dn` | User search. BaseDN to start the search from | |
| `dex.connectors.ldap.search.usernameAttr` | Username attribute used for comparing user entries | `uid` |
| `dex.connectors.ldap.search.filter` | Optional filter to apply when searching the directory | `(objectClass=user)` |
| `dex.connectors.ldap.search.idAttr` | String representation of the user | `uid` |
| `dex.connectors.ldap.groupSearch.dn` | Group search. BaseDN to start the search from | `${dex.ldap.search.dn}` |
| `dex.connectors.okta.issuer` | OKTA issuer URL | |
| `dex.connectors.okta.clientId` | OKTA Oauth2 client id | |
| `dex.connectors.okta.clientSecret` | OKTA Oauth2 client secret | |

## Outputs

| Name | Description |
| :--- | :---        |
| `dex.api.endpoint` | Dex API endpoint URL |
| `dex.issuer` | Dex issuer URL |

## References

* [DEX](https://dexidp.io/)
