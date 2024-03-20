# Kubeflow Tensorboard app

This web application provides Web UI to manage Tensorboard instances in the user's profile.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml  
components:
  - name: kubeflow-tensorboard
    source:
      dir: components/kubeflow-tensorboard
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-tensorboard
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy -c kubeflow-tensorboard
```

## Requirements

- [Kustomize](https://kustomize.io)
- [kubeflow-common](../kubeflow-common)
- [kubeflow-profiles](../kubeflow-profiles)
- [istio-ingressgateway](../istio-ingressgateway)

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                    | Description                                               | Default Value                                                                     | Required |
|-------------------------|-----------------------------------------------------------|-----------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Kubernetes namespace for this component                   | `kubeflow`                                                                        |          |
| `kubeflow.version`      | Kubeflow version                                          | `v1.6.1`                                                                          |          |
| `kustomize.tarball.url` | URL to kubeflow tarball archive                           | [kubeflow manifest](https://github.com/kubeflow/manifests/tree/master)            |          |
| `kustomize.subpath`     | Tarball archive subpath where kustomize files are located | [tensorboard](https://github.com/kubeflow/manifests/tree/master/apps/tensorboard) |          | 

## Implementation Details

This component will deploy two services of the Tensorboard

* [tensorboard-controller](notebook-controller) - a BFF (backend-for-frontend) of the web application
* [tensorboards-web-app](tensorboards-web-app) - web application

```text
./
├── tensorboard-controller              # backend for UI and operator for tensorboards
│   └── kustomization.yaml.template     # kustomize deployment manifest
├── tensorboards-web-app                # contains kustomize scr
│   └── kustomization.yaml.template     # kustomize deployment manifest
├── hub-component.yaml                  # configuration and parameters file of Hub component
└── kustomization.yaml.template         # main kustomize template file
```

## See Also

* Central Dashboard on Kubeflow [website](https://www.kubeflow.org/docs/components/central-dash/overview/)
