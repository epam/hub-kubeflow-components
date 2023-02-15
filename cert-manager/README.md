# Cert Manager

## Description

The helm based component deploys cloud native certificate management for Kubernetes

## Structure

The component has the following directory structure:

```text
./
├── hub-component.yaml             # manifest file of the component with configuration and parameters
└── values.yaml.template           # helm values hub cli template
```

## Parameters

| Name      | Description | Default Value | Required
| :-------- | :--------   | :--------     | :--:
| `certmanager.version` | Version of cert-manager | `v1.11.1` |
| `certmanager.namespace` | Kubernetes namespace | `kube-system` |
| `helm.repo` | Helm chart repo | <https://charts.jetstack.io> |
| `helm.chart` | Helm chart name | `cert-manager` |

## Dependencies

The component requires:

* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)

## References

* [hub cli](https://github.com/agilestacks/hub/wiki)
