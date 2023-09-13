# Kubeflow Jupyter Notebook

A web application to allow user to create, update and delete Jupyter Notebooks inside their profile. This application
can work as a standalone application, however by default it wll be opened from Kubeflow Central dashboard via iframe.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml  
components:
  - name: kubeflow-jupyter
    source:
      dir: components/kubeflow-jupyter
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-jupyter
```

To initiate the deployment, run the following commands:

  ```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy -c kubeflow-jupyter
```

## Requirements

- Kubernetes
- [Kustomize](https://kustomize.io)
- [Istio Ingress Gateway](../istio-ingressgateway)
- [Kubeflow common](../kubeflow-common)
- [Kubeflow profiles](../kubeflow-profiles)
- [Kubeflow webhooks](../kubeflow-webhooks)

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                        | Description                                                                                                                                                                                 | Default Value                                                                                                                                                                                                                 | Required |
|:----------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`      | Kubernetes namespace for this component                                                                                                                                                     | `kubeflow`                                                                                                                                                                                                                    |          |
| `kubeflow.version`          | Kubeflow version                                                                                                                                                                            | `v1.6.1`                                                                                                                                                                                                                      |          |
| `kustomize.tarball.url`     | URL to kubeflow tarball archive                                                                                                                                                             | [kubeflow manifest](https://github.com/kubeflow/manifests/tree/master)                                                                                                                                                        |          |
| `kustomize.tarball.subpath` | Tarball archive subpath where kustomize files are located                                                                                                                                   | [jupyter-web-app](https://github.com/kubeflow/manifests/tree/master/apps/jupyter/jupyter-web-app/upstream) [notebook-controller](https://github.com/kubeflow/manifests/tree/master/apps/jupyter/notebook-controller/upstream) |          |
| `kustomize.tarball.dir`     | Instructs hubctl to use a specific directory relative to it should extract tarball                                                                                                          | `.`                                                                                                                                                                                                                           |
| `storage.class`             | PV storage class. Empty means default see [spawner config](https://github.com/kubeflow/manifests/blob/v1.5.1/apps/jupyter/jupyter-web-app/upstream/base/configs/spawner_ui_config.yaml#L84) |                                                                                                                                                                                                                               |          |

## Implementation Details

This component will deploy two services of the Jupyter notebook

- [jupyter-web-app](jupyter-web-app) - a web application
- [notebook-controller](notebook-controller) - a BFF (backend-for-frontend) of this application.

Notebook creation form can be customized
in [jupyter-web-app/spawner_ui_config.yaml](jupyter-web-app/configs/spawner_ui_config.yaml.template)
file.

> There was a special update to the notebook to allow user select GPUs from a dropdown.

Once a notebook has been created. In the Kubernetes it has been represented as a Custom Resource (Notebook), so notebook
controller also acts as an operator for this custom resource.

The component has the following directory structure:

```text
./
├── jupyter-web-app                             # jupyter Web application (UI)
│   ├── configs                                 # jupyter web configuration files 
│   │   ├── spawner_ui_config.yaml.template     # extracted notebook creation form config for easier customization
│   |   └── logos-configmap.yaml                # configmap with svg icons
│   └── kustomization.yaml.template             # kustomize script for Jupyter web application
├── notebook-controller                         # backend for UI and operator for Notebooks
│   └── kustomization.yaml.template             # kustomize script for Notebook
├── kustomization.yaml.template                 # main kustomize template file
└── hub-component.yaml                          # configuration and parameters file of Hub component
```

The component uses an official Kubeflow distribution Kustomize [scripts]("https://github.com/kubeflow/manifests/") as a
and applies patches and additional resources described in [kustomize.yaml](kustomization.yaml.template) file.

## See Also

- Central Dashboard on Kubeflow [website](https://www.kubeflow.org/docs/components/central-dash/overview/)
