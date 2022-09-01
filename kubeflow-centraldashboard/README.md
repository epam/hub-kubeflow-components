# Central Dashboard

## Overview of the Kubeflow Central Dashboard

[Central Dashboard](https://www.kubeflow.org/docs/components/central-dash/overview/) is Kubeflow landing page. It provides following functionality:

* Web UI to access all Kubeflow components
* User registration flow

## Implementation Details

The component has the following directory structure:

```text
./
├── deployment_patch.yaml               # Kustomize patch that adds extra env vars for pod
├── hub-component.yaml                  # Parameters definitions
├── kustomization.yaml.template         # Kustomize file for ths component
├── links-config.json                   # Configuration for splash screen
├── params.env.template                 # Configuration for environment variables of a central-dashboard pod
├── params.yaml                         # Config for Kustomize varibles
├── pre-deploy                          # Script to download tarball from kubeflow distribution website
├── pre-undeploy -> pre-deploy
├── clusterrole-binding.yaml.template   # RBAC for cluster role bindings
└── role-binding.yaml.template          # RBAC for role bindings
```

The component uses an offical Kubeflow distribution Kustomize [scripts](https://github.com/kubeflow/manifests/) and applies patches and additional resources described in [kustomize.yaml](https://github.com/agilestacks/kubeflow-components/blob/main/kubeflow-centraldashboard/kustomization.yaml.template) file.

Where [pre-deploy](https://github.com/agilestacks/kubeflow-components/blob/main/kubeflow-centraldashboard/pre-deploy) script has been responsible for download tarball from Kubeflow official distribution website.

This component contains a special parameters to enable image pull from private docker registry

By default in the Kubeflow user id has been a valid email address. This is not the case for Intel, where user id is an `IDSID` parameter (from LDAP) which is not an email address. To allow this, we had to relax a user field validation in Add Contributor UI screen

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `component.kubeflow.name` | Target Kubernetes resources name for this component | |
| `component.kubeflow.namespace` | Target Kubernetes namespace for this component | |
| `component.kubeflow.version` | Version of Kubeflow | `v1.5.1` |
| `component.kubeflow.centraldashboard.kustomize.tarball` | URL to kubeflow tarball archive | `https://codeload.github.com/kubeflow/manifests/tar.gz/${component.kubeflow.version}` |
| `component.kubeflow.centraldashboard.kustomize.subpath` | Tarball archive subpath where kustomize files are located | `apps/centraldashboard/upstream` |

## See Also

* Central Dashboard [official documentation](https://www.kubeflow.org/docs/components/central-dash/overview/)
* Project source code on [Github](https://github.com/kubeflow/kubeflow/tree/master/components/centraldashboard)
