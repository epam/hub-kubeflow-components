# DEX

## Overview of Argo Workflows

Dex is an identity service that uses [OpenID Connect](https://openid.net/connect/) to drive authentication for other apps.

Dex acts as a portal to other identity providers through [“connectors.”](https://dexidp.io/docs/connectors/) This lets Dex defer authentication to LDAP servers, SAML providers, or established identity providers like GitHub, Google, and Active Directory. Clients write their authentication logic once to talk to Dex, then Dex handles the protocols for a given backend.

## Implementation Details

The Argo Workflows Component has the following directory structure:

```text
./
├── kubernetes          # DEX related kubernetes resources and CRDs
├── hub-component.yaml  # Component definition file
├── deploy.sh           # Deploy script
└── undeploy.sh         # Undeloy script
```

## Parameters

The following component level parameters can be set in `hub-component.yaml`:

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `dns.domain` | Domain name of the kubeflow stack | |
| `component.ingress.protocol` | HTTP or HTTPS schema | `https` |
| `component.ingress.class` | Name of ingress class in kubernetes | |
| `component.ingress.ssoUrlPrefix` | Url prefix for protected applications | `dex` |
| `component.dex.name` | Name of Dex kubernetes resources | `dex` |
| `component.dex.namespace` | Name of kubernetes namespace where Dex will be deployed | `kube-system` |
| `component.dex.oidcIssuerFqdn` | Url of Dex issuer | `auth.${dns.domain}` |
| `component.dex.image` | Dex docker image | `dexidp/dex:v2.26.0` |
| `component.dex.passwordDb.email` | Static password DB user email | |
| `component.dex.passwordDb.password` | Static password DB user password | |
| `component.dex.ldap.host` | Host and optional port of the LDAP server in the form "host:port" | |
| `component.dex.ldap.dn` | The DN for an application service account | |
| `component.dex.ldap.usernamePrompt` | The attribute to display in the provided password prompt | `Username` |
| `component.dex.ldap.password` | The password for an application service account | |
| `component.dex.ldap.search.dn` | User search. BaseDN to start the search from | |
| `component.dex.ldap.search.usernameAttr` | Username attribute used for comparing user entries | `uid` |
| `component.dex.ldap.search.filter` | Optional filter to apply when searching the directory | `(objectClass=user)` |
| `component.dex.ldap.search.idAttr` | String representation of the user | `uid` |
| `component.dex.ldap.groupSearch.dn` | Group search. BaseDN to start the search from | `${component.dex.ldap.search.dn}` |
| `component.dex.authproxy.image` | Docker image of ASI oauth2 proxy | `agilestacks/oauth2_proxy:v2.3` |
| `component.dex.authOperator.image` | Docker image of auth operator | `agilestacks/auth-operator:0.1.1` |
| `component.dex.authproxy.emailDomain` | Authenticate emails with the specified domain. Use * to authenticate any email | `'*'` |
| `component.dex.authproxy.cookieExpire` | Expire timeframe for cookie | `'12h0m0s'` |

## References

* [DEX](https://dexidp.io/)
* [ASI Auth operator](https://github.com/agilestacks/auth-operator)
* [ASI OAuth2 proxy](https://github.com/agilestacks/oauth2_proxy)
