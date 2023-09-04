# Kubeflow Jupyter Notebook

A web application to allow user to create, update and delete Jupyter Notebooks inside their profile. This application
can work as a standalone application, however by default it wll be opened from Kubeflow Central dashboard via iframe.

## TL;DR

Declare hubctl stack with

```shell
cat << EOF > hub.yaml
version: 1
kind: stack

requires:
  - kubernetes
  
components:  
  - name: kubeflow-jupyter
    source:
      dir: components/kubeflow-jupyter
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-jupyter
    depends:
      - istio-ingressgateway
      - kubeflow-common
      - kubeflow-profiles
      - kubeflow-webhooks  
EOF

hubctl stack init
hubctl stack deploy
```

## Requirements

- Kubernetes
- [kustomize](https://kustomize.io) CLI.

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                    | Description                                    | Default Value                                                               | Required 
|-------------------------|------------------------------------------------|-----------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component | `kubeflow`                                                                  |          |
| `kubeflow.version`      | Version of Kubeflow                            | `v1.5.1`                                                                    |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                | `https://codeload.github.com/kubeflow/manifests/tar.gz/${kubeflow.version}` |          |
| `kustomize.subpath`     | Directories from kubeflow tarball archive      |                                                                             |          |
| `storage.class`         | PV storage class                               |                                                                             |          |

## Implementation Details

This component will deploy two services of the Jupyter notebbok

* [jupyter-web-app](jupyter-web-app) - a web application
* [notebook-controller](notebook-controller) - a BFF (backend-for-frontend) of this applicaiton.

Notebook creation form can be customized
in [jupyter-web-app/spawner_ui_config.yaml](components/kubeflow-jupyter/jupyter-web-app/spawner_ui_config.yaml.template)
file.

> There was a special update to the notebook to allow user select GPUs from a dropdown.

Once a notebook has been created. In the Kubernetes it has been represented as a Custom Resource (Notebook), so notebook
controller also acts as an operator for this custom resource.

The component has the following directory structure:

```text
./
├── jupyter-web-app                             # Jupyter Web application (UI)
│   ├── configs                                 # Jupyter web configuration files 
│   │   ├── spawner_ui_config.yaml.template     # Extracted notebook creation form config for easier customization
│   |   └── logos-configmap.yaml                # Configmap with svg icons
│   └── kustomization.yaml.template             # Kustomize script for Jupyter web application
├── notebook-controller                         # Backend for UI and operator for Notebooks
│   └── kustomization.yaml.template             # Kustomize script for Notebook
├── kustomization.yaml.template                 # Main kustomize template file
├── README.md                                   
└── hub-component.yaml                          # Configuration and parameters file of Hub component
```

The component uses an official Kubeflow distribution Kustomize [scripts]("https://github.com/kubeflow/manifests/") as a
and applies patches and additional resources described in [kustomize.yaml](kustomize.yaml.template) file.

## See Also

* Central Dashboard on Kubeflow [website](https://www.kubeflow.org/docs/components/central-dash/overview/)
