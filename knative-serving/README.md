# Knative Serving

Knative Serving builds on Kubernetes to support deploying and serving of serverless applications and functions. Serving
is easy to get started with and scales to support advanced scenarios. The Knative Serving project provides middleware
primitives that enable: rapid deployment, autoscaling, routing, network programming and ingress, monitoring, and domain
mappings.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml`file

```yaml
components:
  - name: knative-serving
    source:
      dir: components/knative-serving
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: knative-serving
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c knative-serving
```

## Requirements

- [Helm](https://helm.sh/docs/intro/install/)
- Kubernetes
- [Kustomize](https://kustomize.io)
- `Issuer`
- `Certificate`

## Parameters

| Name                                               | Description                                                                                                       | Default Value                                                                                          | Required |
|----------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`                             | Kubernetes namespace                                                                                              | `knative-serving`                                                                                      |          |
| `knative.version`                                  | Knative Version of kustomize serving                                                                              | `v1.9.2`                                                                                               |          |
| `knative.autoscaling.scaleToZero`                  | Enable scale to zero [behavior](https://knative.dev/docs/serving/autoscaling/scale-to-zero/#enable-scale-to-zero) | `true`                                                                                                 |          |
| `knative.autoscaling.scaleToZeroGracePeriod`       | Enable scale to zero period                                                                                       | `5m`                                                                                                   |          |
| `knative.autoscaling.stableWindow`                 | Behavior for stable mode see [details](https://knative.dev/docs/serving/autoscaling/kpa-specific/#modes)          | `180s`                                                                                                 |          |
| `knative.autoscaling.initialScale`                 | Initial replicas                                                                                                  | `1`                                                                                                    |          |
| `knative.autoscaling.minScale`                     | Min scale replicas                                                                                                | `0`                                                                                                    |          |
| `knative.autoscaling.maxScale`                     | Max scale replicas                                                                                                | `0`                                                                                                    |          |
| `knative.podspec.nodeSchedulling`                  | `enabled` or `disabled` enables support for node scheduling. Cannot be safely disabled once enabled               | `disabled`                                                                                             |          |
| `knative.networking.autocreateClusterDomainClaims` | Enables `ClusterDomainlaims` publishing                                                                           | `true`                                                                                                 |          |
| `knative.networking.autoTLS`                       | Enables auto tls configuration                                                                                    | `Disabled`                                                                                             |          |
| `knative.networking.ingresClass`                   | Configures knative service ingress class                                                                          | `istio.ingress.networking.knative.dev`                                                                 |          |
| `knative.networking.certificateClass`              | Configures certificates if TLS enabled                                                                            | `cert-manager.certificate.networking.knative.dev`                                                      |          |
| `knative.hpa`                                      | If `enabled` then install optional `hpa` configuration                                                            | `disabled`                                                                                             |          |
| `knative.istio`                                    | If `enabled` then install optional `istio` configuration                                                          | `enabled`                                                                                              |          |
| `istio.namespace`                                  | Only affected when `kantive.istio=enabled`. Point to istio-namespace                                              | `istio-system`                                                                                         |          |
| `istio.ingressGateway`                             | Only affected when `kantive.istio=enabled`. Service name of istio ingress gateway                                 |                                                                                                        |          |
| `ingress.hosts`                                    | If defines then enables external domain configuration                                                             | `svc.cluster.local`                                                                                    |          |
| `ingress.protocol`                                 | `http` or `https` external domain configuration                                                                   | `http`                                                                                                 |          |
| `kustomize.crd`                                    | Version specific CRD to download CRDs                                                                             | `https://github.com/knative/serving/releases/download/knative-${kubernetes.version}/serving-crds.yaml` |          |
| `kustomize.resources`                              | Kubernetes resources to be downloaded to `./kustomize` directory                                                  | `URLs`                                                                                                 |          |

## Implementation Details

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

Deployment follows to the following algorithm:

1. The deployment is based on the basic installation procedure described
   here [Knative Serving](https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/). Regardless
   installation procedure is referencing to YAML files that will be downloaded from the official repository. The
   component
   is using `kustomize` extension to apply YAML files previously downloaded by the `pre-deploy` script.
2. Contains list of resources kubernetes resources to download. These resources will be stored in `./kustomize`
   directory
   and available for `kustomization.yaml` to be executed.
3. There is a hard dependency on cert-manager to generate self-signed certificates for the webhooks.
4. Istio is the optional for this component. It is enabled as `istio` overlay if parameter `knative.istio` is set
   to `enabled`. Script `pre-deploy` will check this parameter and add to `kustomization.yaml`
5. Because KNative is using webhooks there is a dependency on `cert-manager` which has been enabled as overlay. This
   overlay will define a `self signed` certificate issuer in namespace defined by `kubernetes.namespace` and the webhook
   certificates as Cert Manager `Certificate` resources.
6. KNative can optionally use `HPA` to scale the pods. This is alternative to Serverless mode managed by istio. This
   mode
   can be enabled by setting parameter `knative.hpa` to `enabled`. Then `pre-deploy` script will add
   resource `kustomize/serving-hpa.yaml` to the `kustomization.yaml` file. This file has been downloaded as part
   of `kustomize.resources` parameter.
7. Knative autoscaler configuration is defined in `config-autoscaler` config map. The component is using `kustomize` to
   patch the config map. The patch is defined in `kustomization.yaml` file. Visit kustomization file template to change
   autoscaler behavior. Knative network configuration is defined in `config-network` config map.
   Configmap `config-network` content details can be
   found [here](https://github.com/knative/serving/blob/main/vendor/knative.dev/networking/config/config-network.yaml)
8. If parameter `ingress.hosts` is defined then kustomization file template will render `config-domain` config map patch
   with external domain hosts. To define ingres traffic for external domains user needs to define parameters: See
   details [here](https://knative.dev/docs/serving/using-a-custom-domain/#procedure)
9. Config features is used to control pod scheduling behavior and controlled via `config-features` config map. See how
   enable [node scheduling](https://kserve.github.io/website/0.10/modelserving/nodescheduling/inferenceservicenodescheduling/)
   option. This behavior controlled with parameter `knative.podspec.nodeSelector`. See possible values
   for `config-features`
   configmap [here](https://github.com/knative/serving/blob/main/config/core/configmaps/features.yaml). Values for the
   options has been
   explained [here](https://kserve.github.io/website/master/admin/serverless/servicemesh/#turn-on-strict-mtls-and-authorization-policy)
10. This component will fail if `Issuer` and `Certificate` CRD cannot be found. External domains are supported. Yet
    there is no integration with Ingress. When user creates a knative service. Then external domain name will be
    generated. It should be manually propagated to the Ingress.
11. As a workaround for [`2`] user can use `traefik` (enabled in Rancher Desktop by default). This ingress controller
    supports wildcard hosts in Ingress.

## See Also

- [knative](https://knative.dev/)
- Description tables
  for [Installation files](https://knative.dev/docs/install/yaml-install/serving/serving-installation-files/)
- [Scale to Zero](https://knative.dev/docs/serving/autoscaling/scale-to-zero/) Configuration Guide
