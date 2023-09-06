# Kubeflow Profiles

Kubeflow Profile CRD is designed to solve access management within multi-user kubernetes cluster.

Profile access management provides namespace level isolation based on:

* k8s rbac access control
* Istio rbac access control

## Parameters

| Name                    | Description                                         | Default Value                                                               | Required 
|:------------------------|:----------------------------------------------------|:----------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component      |                                                                             |          |
| `kubeflow.name`         | Target Kubernetes resources name for this component |                                                                             |          |
| `kubeflow.version`      | Version of Kubeflow                                 | `v1.2.0`                                                                    |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                     | `https://codeload.github.com/kubeflow/manifests/tar.gz/${kubeflow.version}` |          |
| `kustomize.subpath`     | Directory from kubeflow tarball archive             | `apps/profiles/upstream`                                                    |          |
| `dex.passwordDb.email`  | Administrator email                                 | `bdaml`                                                                     |          |
| `hub.backup.file`       | Profiles backup file                                |                                                                             |          |


## Implementation Details

The component has the following directory structure:

```text
./
├── backup                      # Implementation of backup
├── hub-component.yaml          # Component definition file
├── kustomization.yaml.template # Main kustomize template file
├── post-deploy                 # Restore from backup if backup file is provided
└── README                      # Restore from backup if backup file is provided
```

This component uses Kustomize extension and follows common design guidelines for Kustomize components.

## See Also

* Kubeflow Multi-user
  Isolation [getting started](https://www.kubeflow.org/docs/components/multi-tenancy/getting-started/)
