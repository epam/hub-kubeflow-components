# Cert Manager

Cert-manager adds certificates and certificate issuers as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates. 
The helm based component deploys cloud native certificate management for Kubernetes.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml`file

```yaml
components:
- name: cert-manager
  source:
    dir: components/cert-manager
    git:
      remote: https://github.com/epam/hub-kubeflow-components.git
      subDir: cert-manager
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c cert-manager
```

## Requirements

* [Helm](https://helm.sh/docs/intro/install/)
* Kubernetes

## Parameters

The following component level parameters can be set in `hub-component.yaml`:

| Name                        | Description                                                         | Default Value                                                   | Required |
|-----------------------------|---------------------------------------------------------------------|-----------------------------------------------------------------|:--------:|
| `kubernetes.namespace`      | Kubernetes namespace                                                | `kube-system`                                                   |          |
| `kubernetes.serviceAccount` | Kubernetes service Account                                          |                                                                 |          |
| `certmanager.version`       | Version of cert-manager                                             | `v1.12.4`                                                       |          |
| `helm.repo`                 | Helm chart repo                                                     | [jetstack](https://charts.jetstack.io)                          |          |
| `helm.chart`                | Helm chart name                                                     | `cert-manager`                                                  |          |
| `helm.crd`                  | Custom Resource Definitions                                         | [github](https://github.com/cert-manager/cert-manager/releases) |          |
| `helm.baseValues`           | Instructs hubctl to use values.yaml files from helm chart as a base | `values.yaml`                                                   |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml             # manifest file of the component with configuration and parameters
└── values.yaml.template           # helm values hub cli template

```

If `kubernetes.serviceAccount` is not specified, the component will create a new service account `cert-manager` in the `kubernetes.namespace` namespace.

### Add Lets Encrypt Issuer

Cert-manager have been deployed in the cluster without any specific configuration. It should be added as the deployment hooks in the `hub.yaml`. Following example shows how to add a Lets Encrypt Cluster Issuer that uses Google Cloud DNS for DNS01 challenge.

Create a file `bin/cert-manager-post-deploy.sh` with the following content:

```bash
#!/bin/sh -e

cat <<EOF | kubectl apply -f - 
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: cert-manager
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: devops@epam.com
    privateKeySecretRef:
      name: cert-manager-issuer
    solvers:
    - dns01:
        cloudDNS:
          project: ${GOOGLE_PROJECT}
EOF
```

> Note: `GOOGLE_PROJECT` is a well known environment variable set in the `.env` file stacks that requires `gcp`.

Add execution rights to the `bin/cert-manager-post-deploy.sh` file

```bash
chmod +x bin/cert-manager-post-deploy.sh
```

Declare a post-deploy hooks for `cert-manager` component in the `hub.yaml` file:

```yaml
components:
- name: cert-manager
  # ...
  hooks:
  - file: bin/cert-manager-post-deploy.sh
    triggers: [post-deploy]
```

### Additional parameters

There are literally many ways how to configure cert-manager. We have got rather opinionated setup for Let's Encrypt. If you need to configure cert-manager in a different way, you can use `pre-deploy` hook to add extra configuration for helm chart.

Look here for additional parameters you want to add: [all values]([Title](https://github.com/cert-manager/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml))

Create a file `bin/cert-manager-pre-deploy.sh` with execution rights

```bash
#/bin/sh -e
cat << EOF > values-generated.yaml
global:
  logLevel: 0
EOF
```

> Stanza above set log level to 0 (trace) for cert-manager. It is useful for debugging. See troubleshooting [guide](https://cert-manager.io/docs/troubleshooting//)

## See also

* [Cert-manager](https://cert-manager.io/docs/)
* [External DNS Component](https://github.com/epam/hub-kubeflow-components/tree/develop/external-dns)
