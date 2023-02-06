# Knative Eventing

Knative eventing is based on the [CloudEvents](https://cloudevents.io/) specification and provides a declarative way to bind event consumers to event sources. Knative eventing is designed to be extensible and declarative so that different event sources and event consumers can be bound without changing the eventing infrastructure.

## Implementation Details

The deployment is based on the basic installation procedure described here [Knative Eventing](https://knative.dev/docs/install/yaml-install/eventing/install-eventing-with-yaml). Regadless intallation procedure is referncing to YAML files that will be downloaded from the official repository. The component is using `kustomize` extension to apply YAML files previously downloaded by the `pre-deploy` script.

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

## Limitations

At the moment we only support inmemory messaging channel as described here: https://knative.dev/docs/install/yaml-install/eventing/install-eventing-with-yaml/#optional-install-a-default-channel-messaging-layer

We do not yet support any eventing extsions like Kafka, RabbitMQ, etc. Let us know if you need any of those.

## See Also

- [knative](https://knative.dev/)
- Description tables for [Installatin Files](https://knative.dev/docs/install/yaml-install/eventing/eventing-installation-files/)
