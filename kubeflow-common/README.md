# Kubeflow Central Dashboard

This is a HTTP filter for Istio (Envoy) that validates User session and redirects to dex for authentication (if invalid).

## Implementation Details & Parameters

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

The component uses an offical Kubeflow distribution Kustomize [scripts]("https://github.com/kubeflow/manifests/") as a and applies patches and additiona resources described in [kustomize.yaml](kustomize.yaml.template) file.

Where [pre-deploy](pre-deploy) script has been responsible for download tarball from Kubeflow official distribution website.

The following component level parameters has been defined `hub-component.yaml`:

| Name      | Description | Default Value
| --------- | ---------   | ---------
| `component.kubeflow.namespace` | Target Kubernetes namespace for this component | `kubeflow`
| `component.kubeflow.dashboard.image` | Central dashboard docker image configuration | `gcr.io/kubeflow-images-public/centraldashboard`
| `component.kubeflow.dashboard.imageTag` | Central dashboard docker image configuration | `vmaster-g8097cfeb`
| `component.kubeflow.dashboard.contributorFormat` | REGEX to configure validation for profiles congtributor | `^.+$`
| `component.kubeflow.dashboard.contributorValidationMessage` | Custom error message for contributor validation | `^.+$`

## See Also

* Central Dashboard on Kubeflow [website](https://www.kubeflow.org/docs/components/central-dash/overview/)
