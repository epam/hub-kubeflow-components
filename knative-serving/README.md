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

### External Domains

To define ingres traffic for external domains user needs to define parmeters:

* `ingress.hosts` - list ingress hosts to map traffic
* `ingress.protocol` - to let knative know incoming external traffic is `http` or `https`
* `istio.ingressGateway` - service name of istio ingress gateway
* `istio.namespace` - namespace where istio ingress gateway is deployed

External domains has been defined via `ingress.hosts` parameter. If defined then 
confgmap patches will be added to the `kustomization.yaml` file.

1. `config-domain` config map will be patched to add external domains
2. `config-network` config map will be to modify domain tempalte. To make it friendly to wildcard ingresses (traefik supports that), the template defines `name-namespace.example.com` to keep routes on a single level.

See more about possible configuration to `config-network` [here](https://github.com/knative/serving/blob/main/vendor/knative.dev/networking/config/config-network.yaml)

> Note: Knative is using ingress class to route traffic to the services. This is not the same as kubernetes ingress class. 


### Limitations

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
