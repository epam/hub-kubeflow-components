# Kubeflow Tensorboard app

This web application provides Web UI to manage Tensorboard instances in the user's profile.

## TL;DR

```shell
cat << EOF > hub.yaml
version: 1
kind: stack

requires:
  - kubernetes
  
components:
  - name: kubeflow-tensorboard
    source:
      dir: components/kubeflow-tensorboard
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-tensorboard
    depends:
      - kubeflow-common
      - kubeflow-profiles
      - istio-ingressgateway
EOF

hubctl stack init
hubctl stack deploy      
```

## Requirements

- [kustomize](https://kustomize.io)
- [kubeflow-common](/kubeflow-common)
- [kubeflow-profiles](/kubeflow-profiles)
- [istio-ingressgateway](/istio-ingressgateway)

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                    | Description                                    | Default Value                                                               | Required 
|-------------------------|------------------------------------------------|-----------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component | `kubeflow`                                                                  |          |
| `kubeflow.version`      | Version of Kubeflow                            | `v1.6.1`                                                                    |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                | `https://codeload.github.com/kubeflow/manifests/tar.gz/${kubeflow.version}` |          |
| `kustomize.subpath`     | Directories from kubeflow tarball archive      |                                                                             |          | 

## Implementation Details

This component will deploy two services of the Tensorboard

* [tensorboard-controller](notebook-controller) - a BFF (backend-for-frontend) of the web application
* [tensorboards-web-app](tensorboards-web-app) - web application

```text
./
├── tensorboard-controller              # Backend for UI and operator for tensorboards
│   └── kustomization.yaml.template     # Kustomize deployment manifest
├── tensorboards-web-app                # Contains kustomize scr
│   └── kustomization.yaml.template     # Kustomize deployment manifest
├── hub-component.yaml                  # Configuration and parameters file of Hub component
└── kustomization.yaml.template         # Main kustomize template file
```

## See Also

* Central Dashboard on Kubeflow [website](https://www.kubeflow.org/docs/components/central-dash/overview/)
