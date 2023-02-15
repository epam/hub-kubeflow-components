# Knative Serving

Knative Serving builds on Kubernetes to support deploying and serving of serverless applications and functions. Serving is easy to get started with and scales to support advanced scenarios. The Knative Serving project provides middleware primitives that enable: rapid deployment, autoscaling, routing, network programming and ingress, monitoring, and domain mappings.

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `knative.version` | Version of kustomize serving | `v1.9.2` |
| `knative.serving.namespace` | Kubernetes namespace | `knative-serving` |
| `knative.serving.crd` | Version specific CRD to download CRDs | `URL` |
| `knative.serving.autoscaling.scaleToZero` | Enable scale to zero [behavior](https://knative.dev/docs/serving/autoscaling/scale-to-zero/#enable-scale-to-zero) | `true` |
| `knative.serving.autoscaling.stableWindow` | Behavior for stable mode see [details](https://knative.dev/docs/serving/autoscaling/kpa-specific/#modes) | `60s` |
| `knative.serving.autoscaling.initialScale` | Initial replicas | `1` |
| `knative.serving.autoscaling.minScale` | Min scale replicas | `0` |
| `knative.serving.autoscaling.maxScale` | Max scal replicas | `0` |
| `knative.serving.autoscaling.maxScale` | Max scal replicas | `0` |
| `knative.serving.hpa` | If `enabled` then install optional `hpa` configuration | `disabled` |
| `knative.serving.istio` | If `enabled` then install optional `istio` configuration | `enabled` |
| `istio.namespace` | Only affected when `kantive.serving.istio=enabled`. Point to istio-namespace  |`istio-system`|
| `istio.ingressGateway` | Only affected when `kantive.serving.istio=enabled`. Service name of istio ingress gateway | |
| `kustomize.resources` | Contains list of resources kubernetes resources to download. These resourcs will be stored in `./kustomize` directory and available for `kustomization.yaml` to be executed.  | whitespace separated URLs |

## Implementation Details

The deployment is based on the basic installation procedure described here [Knative Serving](https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/). Regadless intallation procedure is referncing to YAML files that will be downloaded from the official repository. The component is using `kustomize` extension to apply YAML files previously downloaded by the `pre-deploy` script.

The component has the following directory structure:

```text
./
├── cert-manager
│   ├── certificate.yaml.template
│   └── kustomization.yaml.template       # Template for kustomize to drive cert-manager overlay
├── istio
│   ├── kustomization.yaml.template       # Template for kustomize to drive istio overlay
│   └── peer-auth.yaml                    # Peer authentication policy            
├── hub-component.yaml                    # Component definition
├── kustomization.yaml.template           # Template for kustomize file that will drive the deployment
└── pre-deploy                            # Pre deploy script (see implementation details)
```

1. At first resoruces from `kustomize.resources` will be downloaded and stored in `./kustomize` directory. 
2. Then the `pre-deploy` script will be executed. The script will check `enabled/disabled` parameters and add optional overlays to the `kustomization.yaml` file. 3. Then the `kustomize` will be executed to deploy the component.

There is a hard dependency on cert-manager to generate self signed certificates for the webhooks. 

###  Dependencies

* Cert Manager - KNative is using webhoooks. Cert Manager is used to generate and inject certificates into the webhooks. 
* Istio Ingress Gateway (optional) - if defined via parameter `istio.ingressGateway` then the component will run `./istio` overlay

### Limitations

This component will fail if `Issuer` and `Certificate` CRD cannot be found

## See Also

- [knative](https://knative.dev/)
- Description tables for [Installation files](https://knative.dev/docs/install/yaml-install/serving/serving-installation-files/)
- [Scale to Zero](https://knative.dev/docs/serving/autoscaling/scale-to-zero/) Configuration Guide
