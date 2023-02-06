# ETCD

[etcd](https://etcd.io) is a distributed key-value store that provides a reliable way to store data across a cluster of machines. etcd gracefully handles master elections during network partitions and will tolerate machine failure, including the master.

etcd is used by Kubernetes as the backing store for all cluster data. However etcd can be used for other purposes as well such as backend for services such as KServe Model Mesh. In this case we don't want to mess with Kubernetes etcd, but rather use it as a separate service.

## Structure

This component is using helm chart from [bitnami](https://charts.bitnami.com/bitnami) repository. The component contains only the manifest file and the template for the values file.

```text
./
├── hub-component.yaml    # manifest file of the component with configuration and parameters
└── values.yaml.template  # hubctl template of helm chart values
```

## Parameters

| Name      | Description | Default Value | Required
| :-------- | :--------   | :--------     | :--:
`etcd.namespace` | Target namespace to install etcd | `etcd` | x |
`etcd.rootPassword` | Root password |  | x |
`etcd.volumeSize` | PVC size for etcd storage | `8Gi` | x |
`storage.class` | PV storage class | | |
`helm.repo` | Helm chart repository | <https://charts.bitnami.com/bitnami> | x |
`helm.chart` | Helm chart name | `etcd` | x |
`helm.baseValuesFile` | Instructs which file from the helm to use as values basis | `values.yaml` | |

## Referneces

* [etcd](https://etcd.io)
* [hubctl](superhub.io)
