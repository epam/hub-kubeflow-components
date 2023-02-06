# Knative Serving

Knative Serving builds on Kubernetes to support deploying and serving of serverless applications and functions. Serving is easy to get started with and scales to support advanced scenarios. The Knative Serving project provides middleware primitives that enable: rapid deployment, autoscaling, routing, network programming and ingress, monitoring, and domain mappings.

## Implementation Details

The deployment is based on the basic installation procedure described here [Knative Serving](https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/). Regadless intallation procedure is referncing to YAML files that will be downloaded from the official repository. The component is using `kustomize` extension to apply YAML files previously downloaded by the `pre-deploy` script.

The component has the following directory structure:

```text
./
├── hub-component.yaml                    # Component definition
├── pre-deploy                            # Script to download YAML files
└── kustomization.yaml.template           # Template for kustomize file that will drive the deployment
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `knative.version` | Version of kustomize serving | `v1.9.2` |
| `knative.serving.namespace` | Kubernetes namespace | `knative-serving` |
| `knative.serving.crd` | Version specific CRD to download CRDs | `URL` |


## See Also

- [knative](https://knative.dev/)
- Description tables for [Installation files](https://knative.dev/docs/install/yaml-install/serving/serving-installation-files/)
