# External DNS

ExternalDNS synchronizes exposed Kubernetes Services and Ingresses with DNS providers.

## TL;DR

```yaml
  - name: external-dns
    source:
      dir: components/external-dns
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: external-dns
```

To initiate the deployment, run the following commands:
```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c external-dns
```

## Requirements

- [Helm](https://helm.sh/docs/intro/install/)
- Kubernetes

## Parameters

| Name                              | Description                                                              | Default Value                        | Required |
|-----------------------------------|--------------------------------------------------------------------------|--------------------------------------|:--------:|
| `kubernetes.namespace`            | Kubernetes namespace                                                     | `kube-system`                        |          |
| `kubernetes.serviceAccount`       | Kubernetes service Account                                               |                                      |    x     |
| `externalDns.txtOwnerId`          | To mark that current instance of external dns is managing DNS record     | value of `hub.deploymentId`          |          |
| `externalDns.syncIntervalSeconds` | How often to reconcile ingresses with DNS records in the Cloud (seconds) | `30`                                 |          |
| `externalDns.syncPolicy`          | DNS records policy policy (`sync` or `upsert-only`)                      | `upsert-only`                        |          |
| `externalDns.domainFilters`       | Space separated list of dns zones to manage by this external-dns         | value of `dns.domain`                |          |
| `helm.repo`                       | Helm chart repository URL                                                | <https://charts.bitnami.com/bitnami> |          |
| `helm.chart`                      | Helm chart name                                                          | `external-dns`                       |          |
| `helm.version`                    | Helm chart version                                                       | `6.10.2`                             |          |
| `helm.valuesFile`                 | File for helm chart values                                               | `values.yaml`                        |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml    # manifest file of the component with configuration and parameters
└── values.yaml.template  # hubctl template of helm chart values
```

Deployment follows to the following algorithm:
1. At the beginning hubctl need to create a Kubernetes cluster and other dependency components.
2. It is recommended to create service account ${SERVICE_ACCOUNT} in namespace ${NAMESPACE} before deployment. Annotate `kubernetes.serviceAccount` service account in the`kubernetes.namespace` with aws role and region (for example, if it's for aws)
3. Then start deployment

## See also

* [External DNS](https://github.com/kubernetes-sigs/external-dns)
* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)
