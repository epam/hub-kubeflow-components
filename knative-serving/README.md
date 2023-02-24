# Knative Serving

Knative Serving builds on Kubernetes to support deploying and serving of serverless applications and functions. Serving is easy to get started with and scales to support advanced scenarios. The Knative Serving project provides middleware primitives that enable: rapid deployment, autoscaling, routing, network programming and ingress, monitoring, and domain mappings.

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `knative.version` | Version of kustomize serving | `v1.9.2` |
| `knative.namespace` | Kubernetes namespace | `knative-serving` |
| `knative.crd` | Version specific CRD to download CRDs | `URL` |
| `knative.autoscaling.scaleToZero` | Enable scale to zero [behavior](https://knative.dev/docs/serving/autoscaling/scale-to-zero/#enable-scale-to-zero) | `true` |
| `knative.autoscaling.stableWindow` | Behavior for stable mode see [details](https://knative.dev/docs/serving/autoscaling/kpa-specific/#modes) | `60s` |
| `knative.autoscaling.initialScale` | Initial replicas | `1` |
| `knative.autoscaling.minScale` | Min scale replicas | `0` |
| `knative.autoscaling.maxScale` | Max scal replicas | `0` |
| `knative.autoscaling.maxScale` | Max scal replicas | `0` |
| `knative.networking.autocreateClusterDomainClaims` | Enables `ClusterDomainlaims` publishing | `Disabled` |
| `knative.networking.autoTLS` | Enables auto tls configuration | `Disabled` |
| `knative.networking.ingresClass` | Configures knative service ingress class | `istio.ingress.networking.knative.dev` |
| `knative.networking.certificateClass` | Configures certificates if TLS enabled | `cert-manager.certificate.networking.knative.dev` |
| `knative.hpa` | If `enabled` then install optional `hpa` configuration | `disabled` |
| `knative.istio` | If `enabled` then install optional `istio` configuration | `enabled` |
| `istio.namespace` | Only affected when `kantive.istio=enabled`. Point to istio-namespace  |`istio-system`|
| `istio.ingressGateway` | Only affected when `kantive.istio=enabled`. Service name of istio ingress gateway | |
| `ingress.hosts` | If defines then enables external domain configuration | |
| `ingress.protocol` | `http` or `https` external domain configuration | |
| `kustomize.resources` | Contains list of resources kubernetes resources to download. These resourcs will be stored in `./kustomize` directory and available for `kustomization.yaml` to be executed.  | whitespace separated URLs |

## Implementation Details

The deployment is based on the basic installation procedure described here [Knative Serving](https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/). Regadless intallation procedure is referncing to YAML files that will be downloaded from the official repository. The component is using `kustomize` extension to apply YAML files previously downloaded by the `pre-deploy` script.

The component has the following directory structure:

```text
./
├── cert-manager                                  # Overlay for cert-manager
│   ├── certificate.yaml.template                 # Self signed certificate for webhooks
│   └── kustomization.yaml.template               # Template for kustomize to drive cert-manager overlay
├── istio
│   ├── kustomization.yaml.template               # Template for kustomize to drive istio overlay
│   └── peer-auth.yaml                            # Peer authentication policy            
├── hub-component.yaml                            # Component definition
├── kustomization.yaml.template                   # Template for kustomize file that will drive the deployment
└── pre-deploy                                    # Pre deploy script (see implementation details)
```

1. At first resoruces from `kustomize.resources` will be downloaded and stored in `./kustomize` directory. 
2. Then the `pre-deploy` script will be executed. The script will check `enabled/disabled` parameters and add optional overlays to the `kustomization.yaml` file. 3. Then the `kustomize` will be executed to deploy the component.

There is a hard dependency on cert-manager to generate self signed certificates for the webhooks. 


### Istio 

Istio is the optional for this component. It is enabled as `istio` overlay if parmeter `knative.istio` is set to `enabled`. Script `pre-deploy` will check this parameter and add to `kustomization.yaml`

> Note: user may not have `kustomize` CLI installed. Therefore we are usign `yq` to achieve the same as `kustomize edit add resource`


### Cert Manager 

Because KNative is using webhooks there is a dependency on `cert-manager` which has been enabled as overlay. This overlay will define a `self signed` certificate issuer in namespace defined by `knative.namespace` and the webhook certificates as Cert Manager `Certificate` resources.


### Horizontal Pod Autoscaler (HPA)

KNative can optionaly use `HPA` to scale the pods. This is alternative to Serverless mode managed by istio. This mode can be enabled by setting parameter `knative.hpa` to `enabled`. Then `pre-deploy` script will add resource `kustomize/serving-hpa.yaml` to the `kustomization.yaml` file.

This file has been downloaded as part of `kustomize.resources` parameter.


### Config Autoscaler

Knative autoscaler configuration is defined in `config-autoscaler` config map. The component is using `kustomize` to patch the config map. The patch is defined in `kustomization.yaml` file.

Visit kustomization file template to change autoscaler behavior.

To dissble autoscaling behaviour set autoscaling parameters to:
    
```yaml
parameters:
  knative.autoscaling.initialScale: "1"
  knative.autoscaling.maxScale: "1"
  knative.autoscaling.minScale: "1"
  knative.autoscaling.scaleToZero: "false"
```

### Config Network

Knative network configuration is defined in `config-network` config map. The component is using `kustomize` to patch the config map. The patch is defined in `kustomization.yaml` file. 

Configmap `config-network` content details can be found [here](https://github.com/knative/serving/blob/main/vendor/knative.dev/networking/config/config-network.yaml))

> Note: Knative is using ingress class to route traffic to the services. This is not the same as kubernetes ingress class. 


### Config Domain

If parameter `ingress.hosts` is defined then kustomization file template will render `config-domain` config map patch with external domain hosts.

To define ingres traffic for external domains user needs to define parmeters:

See details [here](https://knative.dev/docs/serving/using-a-custom-domain/#procedure)


## Limitations

1. This component will fail if `Issuer` and `Certificate` CRD cannot be found

2. External domains are supported. Yet there is no integration with Ingress. When user creates a knative service. Then external domain name will be generated. It should be manually propagated to the Ingress

3. As a workaround for [`2`] user can use `traefik` (enabled in Rancher Desktop by default). This ingress controller supports wildcard hosts in Ingress. 


## Troubleshooting

To create sample application use following command:

```
kn service create hello \
    --image "gcr.io/knative-samples/helloworld-go" \
    --port 8080 \
    --env TARGET=World

kn route list -o json | jq -r '.items[0].status.url'
# https://hello-namespace.example.com
curl -v "https://hello-namespace.example.com"
```

To download `kn` cli tool follow [this](https://knative.dev/docs/client/install-kn/) guide


KNative applicaitons debugging issues [guide](https://knative.dev/docs/serving/troubleshooting/debugging-application-issues/)


## See Also

- [knative](https://knative.dev/)
- Description tables for [Installation files](https://knative.dev/docs/install/yaml-install/serving/serving-installation-files/)
- [Scale to Zero](https://knative.dev/docs/serving/autoscaling/scale-to-zero/) Configuration Guide
