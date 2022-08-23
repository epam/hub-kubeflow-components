# Profiles

## Overview of the Kubeflow Profiles controller

Kubeflow Profile CRD is designed to solve access management within multi-user kubernetes cluster.

Profile access management provides namespace level isolation based on:

* k8s rbac access control
* Istio rbac access control

## Implementation Details

```text
./
├── crd                         # Custom resources definitions (CRD)
│   └── profiles.yaml           # Profile CRD
├── backup                      # Implementation of backup
├── hub-component.yaml          # Component definition file
├── kustomization.yaml.template # Main kustomize template file
├── params.yaml                 #
└── post-deploy                 # Restore from backup if backup file is provided
```

This component uses Kustomize extension and follows common design guidelines for Kustomize components.

## Parameters

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `dns.domain` | Domain name of the kubeflow stack | |
| `component.kubeflow.name` | Target Kubernetes resources name for this component | |
| `component.kubeflow.namespace` | Target Kubernetes namespace for this component | |
| `component.kubeflow.version` | Version of Kubeflow | `v1.2.0` |
| `component.kubeflow.tarball` | URL to kubeflow tarball archive | `https://github.com/kubeflow/manifests/archive/${component.kubeflow.version}.tar.gz` |
| `component.kubeflow.tarball.subpath` | Directory from kubeflow tarball archive | `profiles` |
| `dex.passwordDb.email` | Administrator email | `bdaml` |
| `hub.backup.file` | Profiles backup file | |

## See Also

* Kubeflow Multi-user Isolation [getting started](https://www.kubeflow.org/docs/components/multi-tenancy/getting-started/)
