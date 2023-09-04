# Cert Manager

Cert-manager adds certificates and certificate issuers as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates. 
The helm based component deploys cloud native certificate management for Kubernetes.

## TLDR

```yaml
- name: cert-manager
  source:
    dir: components/cert-manager
    git:
      remote: https://github.com/epam/hub-kubeflow-components.git
      subDir: cert-manager

```

## Requirements

- Helm
- Kubernetes

## Parameters

| Name                        | Description                 | Default Value                                                                                       | Required |
|-----------------------------|-----------------------------|-----------------------------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`      | Kubernetes namespace        | `kube-system`                                                                                       |          |
| `kubernetes.serviceAccount` | Kubernetes service Account  |                                                                                                     |          |
| `helm.repo`                 | Helm chart repo             | <https://charts.jetstack.io>                                                                        |          |
| `helm.chart`                | Helm chart name             | `cert-manager`                                                                                      |          |
| `helm.version`              | Version of cert-manager     | `v1.11.1`                                                                                           |          |
| `helm.crd`                  | Custom Resource Definitions | 'https://github.com/jetstack/cert-manager/releases/download/${helm.version}/cert-manager.crds.yaml` |          |

## Implementation Details

The component has the following directory structure:
```text
./
├── hub-component.yaml             # manifest file of the component with configuration and parameters
└── values.yaml.template           # helm values hub cli template

```

Deployment follows to the following algorithm:
1. At the beginning hubctl need to create a Kubernetes cluster and other dependency components.
2. It is recommended to create service account ${SERVICE_ACCOUNT} in namespace ${NAMESPACE} before deployment. Annotate `kubernetes.serviceAccount` service account in the`kubernetes.namespace` with aws role (for example, if it's for aws) or service agent gcp (if you're using the Google Cloud Platform (GCP)).
3. Then start deployment
4. In `post-deploy` it is recommended to create a ClusterIssuer named cert-manager which uses the ACME protocol to manage the issuance of certificates and performs DNS validation via Amazon Route 53 in the specified AWS region (for example if it is for aws) or CloudDNS to the project if you are using GCP.

## See also
* [Cert-manager](https://cert-manager.io/docs/)
* [Helm](https://helm.sh/docs/intro/install/)
* [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/)
* [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine)
* [hub cli](https://github.com/agilestacks/hub/wiki)
