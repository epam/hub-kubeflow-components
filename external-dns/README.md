# External DNS

## Description

ExternalDNS synchronizes exposed Kubernetes Services and Ingresses with DNS providers.

## Structure

The component has the following directory structure:

```text
./
├── hub-component.yaml    # manifest file of the component with configuration and parameters
├── post-deploy           # post deployment hook
├── post-undeploy         # post undeployment hook
├── pre-deploy            # pre deployment hook
├── pre-undeploy          # pre undeployment hook
└── values.yaml.template  # hub cli template of helm chart values
```

## Parameters

| Name      | Description | Default Value | Required
| :-------- | :--------   | :--------     | :--:
component.externalDns.helm.repo | Helm chart repository URL | <https://charts.bitnami.com/bitnami> | |
component.externalDns.helm.chart | Helm chart name | external-dns | |
component.externalDns.helm.version | Helm chart version | 6.1.2 | |
component.externalDns.helm.valuesFile | File for helm chart values | values.yaml | |

## Dependencies

* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)

## References

* [hub cli](https://github.com/agilestacks/hub/wiki)
* [External DNS](https://github.com/kubernetes-sigs/external-dns)
