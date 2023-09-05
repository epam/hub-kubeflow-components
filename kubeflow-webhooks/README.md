# Kubeflow Webhooks

Admission webhook controller in general, intercepts requests to the Kubernetes API server, and can modify and/or
validate the requests. Here the admission webhook is implemented to modify pods based on the available PodDefaults. When
a pod creation request is received, the admission webhook looks up the available PodDefaults which match the pod's
label. It then, mutates the Pod spec according to PodDefault's spec. For the above PodDefault, when a pod creation
request comes which has the label `add-gcp-secret:"true"', it appends the volume and volumeMounts to the pod as
described in the PodDefault spec.

## TL;DR

Declare hubctl stack with

```shell
cat << EOF > hub.yaml
version: 1
kind: stack

requires:
  - kubernetes
  
components:  
  - name: kubeflow-webhooks
    source:
      dir: components/kubeflow-webhooks
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-webhooks
    depends:
      - kubeflow-common
EOF

hubctl stack init
hubctl stack deploy
```

## Requirements

- Requires [kustomize](https://kustomize.io)
- [kubeflow-common](/kubeflow-common)

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                    | Description                                    | Default Value                                                               | Required 
|-------------------------|------------------------------------------------|-----------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component | `kubeflow`                                                                  |          |
| `kubeflow.version`      | Version of Kubeflow                            | `v1.6.1`                                                                    |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                | `https://codeload.github.com/kubeflow/manifests/tar.gz/${kubeflow.version}` |          |
| `kustomize.subpath`     | Directories from kubeflow tarball archive      | `apps/volumes-web-app/upstream`                                             |          |

## Implementation Details

The component has the following directory structure:

```text
./
├── bin                             # Directory contains additional component hooks
│   └── self-signed-ca.sh           # Hook for generating self-signed certificates
├── hub-component.yaml              # Configuration and parameters file of Hub component
├── kustomization.yaml.template     # Main kustomize template file                            
├── post-undeploy                   # Script that is executed after undeploy of the current component
├── pre-deploy                      # Script that is executed before deploy of the current component
└── README.md                       
```

This component uses Kustomize extension and follows common design guidelines for Kustomize components.

## See also

- Kubeflow [Admission webhook](https://github.com/kubeflow/kubeflow/blob/master/components/admission-webhook/README.md)