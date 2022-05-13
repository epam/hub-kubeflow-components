# Cert Manager

## Description

The helm based component deploys cloud native certificate management for Kubernetes

## Structure

The component has the following directory structure:

```text
./
├── hub-component.yaml             # manifest file of the component with configuration and parameters
├── issuer-le-gcp.yaml.template    # hub cli template for cert-manager kubernetes custom resource
├── post-deploy                    # `post-deploy` action implementation of the component
├── post-undeploy                  # `post-undeploy` action implementation of the component
├── pre-deploy                     # `pre-deploy` action implementation of the component
└── values.yaml.template           # helm values hub cli template
```

## Parameters

| Name      | Description | Default Value | Required
| :-------- | :--------   | :--------     | :--:
| `projectId` | GCP project ID | (set on stack level)  | x |
| `dns.domain` | Domain name of the stack | (set on stack level) | x |
| `component.certmanager.version` | Version of cert-manager | v1.3.1 |
| `component.certmanager.namespace` | Kubernetes namespace | kube-system |
| `component.certmanager.clusterIssuer` | Name of ClusterIssuer resource | letsencrypt-superhub-io |
| `component.certmanager.helm.repo` | Helm chart repo | <https://charts.jetstack.io> |
| `component.certmanager.helm.chart` | Helm chart name | cert-manager |

## Outputs

| Name      | Description |
| :-------- | :--------   |
| `component.certmanager.clusterIssuer` | Cert-manager issuer |

## Dependencies

The component requires:

* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)

## References

* [hub cli](https://github.com/agilestacks/hub/wiki)
