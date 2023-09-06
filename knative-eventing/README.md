# Knative Eventing

Knative eventing is based on the CloudEvents specification and provides a declarative way to bind event consumers to event sources. Knative eventing is designed to be extensible and declarative so that different event sources and event consumers can be bound without changing the eventing infrastructure.

## TL;DR

```yaml
  - name: kfserving
    source:
      dir: components/kfserving
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kfserving
```

To initiate the deployment, run the following commands:
```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c kfserving
```

## Requirements

- [Helm](https://helm.sh/docs/intro/install/)
- Kubernetes
- [Kustomize](https://kustomize.io)

## Parameters

| Name                   | Description                                                      | Default Value     | Required |
|------------------------|------------------------------------------------------------------|-------------------|:--------:|
| `kubernetes.version`   | Version of kustomize serving                                     | `v1.9.2`          |          |
| `kubernetes.namespace` | Kubernetes namespace                                             | `knative-serving` |          |
| `kustomize.crd`        | Version specific CRD to download CRDs                            | `URL`             |          |
| `kustomize.resources`  | Kubernetes resources to be downloaded to `./kustomize` directory | `URL`             |          |


## Implementation Details

The component has the following directory structure:
```text
./
├── hub-component.yaml                    # Component definition
└── kustomization.yaml.template           # Template for kustomize file that will drive the deployment
```

Deployment follows to the following algorithm:
1. At the beginning of deployment hubctl will read `kustomize.resources` parameter to download resources from URLs (whitespace separated) to the `./kustomize` directory. So, it would be accessible for `kustomization.yaml` file.
2. The deployment is based on the basic installation procedure described here [Knative Eventing](https://knative.dev/docs/install/yaml-install/eventing/install-eventing-with-yaml). Regadless intallation procedure is referncing to YAML files that will be downloaded from the official repository. 
3. Then start deployment

> Note: At the moment we only support inmemory messaging channel as described here: https://knative.dev/docs/install/yaml-install/eventing/install-eventing-with-yaml/#optional-install-a-default-channel-messaging-layer 
> We do not yet support any eventing extsions like Kafka, RabbitMQ, etc. Let us know if you need any of those.

## See Also

- [knative](https://knative.dev/)
- [CloudEvents](https://cloudevents.io/)
- Description tables for [Installatin Files](https://knative.dev/docs/install/yaml-install/eventing/eventing-installation-files/)
