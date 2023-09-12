# Kubeflow Webhooks

Admission webhook controller in general, intercepts requests to the Kubernetes API server, and can modify and/or
validate the requests. Here the admission webhook is implemented to modify pods based on the available PodDefaults. When
a pod creation request is received, the admission webhook looks up the available PodDefaults which match the pod's
label. It then, mutates the Pod spec according to PodDefault's spec. For the above PodDefault, when a pod creation
request comes which has the label `add-gcp-secret:"true"', it appends the volume and volumeMounts to the pod as
described in the PodDefault spec.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml
components:
  - name: kubeflow-webhooks
    source:
      dir: components/kubeflow-webhooks
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-webhooks
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy -c kubeflow-webhooks
```

## Requirements

- [Kustomize](https://kustomize.io)
- [Kubeflow-common](../kubeflow-common)

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                    | Description                                               | Default Value                                                                                          | Required |
|-------------------------|-----------------------------------------------------------|--------------------------------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component            | `kubeflow`                                                                                             |          |
| `kubeflow.version`      | Version of Kubeflow                                       | `v1.6.1`                                                                                               |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                           | [kubeflow manifest](https://github.com/kubeflow/manifests/tree/master)                                 |          |
| `kustomize.subpath`     | Tarball archive subpath where kustomize files are located | [admission webhook](https://github.com/kubeflow/manifests/tree/master/apps/admission-webhook/upstream) |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── bin                             # directory contains additional component hooks
│   └── self-signed-ca.sh           # hook for generating self-signed certificates
├── hub-component.yaml              # configuration and parameters file of Hub component
├── kustomization.yaml.template     # main kustomize template file                            
├── post-undeploy                   # script that is executed after undeploy of the current component
└── pre-deploy                      # script that is executed before deploy of the current component
```

This component uses Kustomize extension and follows common design guidelines for Kustomize components.

## See also

- Kubeflow [Admission webhook](https://github.com/kubeflow/kubeflow/blob/master/components/admission-webhook/README.md)