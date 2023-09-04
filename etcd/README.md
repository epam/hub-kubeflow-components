# ETCD

ETCD is a distributed key-value store that provides a reliable way to store data across a cluster of machines. etcd gracefully handles master elections during network partitions and will tolerate machine failure, including the master.

Etcd is used by Kubernetes as the backing store for all cluster data. However, etcd can be used for other purposes as well such as backend for services such as KServe Model Mesh. In this case we don't want to mess with Kubernetes etcd, but rather use it as a separate service.

## TLDR

```yaml
  - name: etcd
    source:
      dir: components/etcd
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: etcd
```

## Requirements
- Helm
- Kubernetes

## Parameters

| Name                   | Description                                               | Default Value                        | Required |
|------------------------|-----------------------------------------------------------|--------------------------------------|:--------:|
| `kubernetes.namespace` | Target namespace to install etcd                          | `etcd`                               |          |
| `etcd.rootPassword`    | Root password                                             |                                      |    x     |
| `etcd.volumeSize`      | PVC size for etcd storage                                 | `8Gi`                                |          |
| `storage.class`        | PV storage class                                          |                                      |          |
| `helm.repo`            | Helm chart repository                                     | <https://charts.bitnami.com/bitnami> |          |
| `helm.chart`           | Helm chart name                                           | `etcd`                               |          |
| `helm.baseValuesFile`  | Instructs which file from the helm to use as values basis | `values.yaml`                        |          |

## Implementation Details

This component is using helm chart from [bitnami](https://charts.bitnami.com/bitnami) repository. The component contains only the manifest file and the template for the values file.

```text
./
├── hub-component.yaml    # manifest file of the component with configuration and parameters
└── values.yaml.template  # hubctl template of helm chart values
```

Deployment follows to the following algorithm:
1. At the beginning hubctl need to create a Kubernetes cluster and other dependency components.
2. Then start deployment

## See also

* [etcd](https://etcd.io)
* [Helm](https://helm.sh/docs/intro/install/)
* [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/)
* [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine)
* [hubctl](superhub.io)
