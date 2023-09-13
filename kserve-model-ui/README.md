# KServe-model-ui

he Models web app is responsible for allowing the user to manipulate the Model Servers in their Kubeflow cluster. To achieve this it provides a user friendly way to handle the lifecycle of `InferenceService` CRs.

The web app currently works with v1beta1 versions of InferenceService objects.

The web app is also exposing information from the underlying Knative resources, like Conditions from the Knative Configurations, Route and Revisions as well as live logs from the Model server pod.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml`file

```yaml
components:
  - name: kserve-model-ui
    source:
      dir: components/kserve-model-ui
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kserve-model-ui
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c kserve-model-ui
```

## Requirements

- [Helm](https://helm.sh/docs/intro/install/)
- Kubernetes
- [Kustomize](https://kustomize.io)

## Parameters

| Name                      | Description                                            | Default Value      | Required |
|---------------------------|--------------------------------------------------------|--------------------|:--------:|
| `kubernetes.namespace`    | Target Kubernetes namespace for this component         | `kserve`           |          |
| `kubernetes.version`      | Version of the applicaiton                             | `v1.9.2`           |          |
| `kserve.ui.disableAuth`   | Kserve to disable Auth on gateway requests             | `True`             |          |
| `kserve.ui.path`          | Kserve ui path                                         | `/`                |          |
| `kserve.ui.secureCookies` | Kserve ui secureCookies                                | `False`            |          |
| `ingress.class`           | Kubernetes ingress class to configure ingress traffic  |                    |          |
| `ingress.protocol`        | Ingress traffic protocol (schema)                      | `http`             |          |
| `ingress.hosts`           | List of ingress hosts (Note: only first will be used)  |                    |          |
| `ingress.paths`           | List of ingress paths                                  | /kserve-endpoints/ |          |
| `istio.gateways`          | Istio gatways                                          |                    |          |
| `kustomize.tarball.url`   | URL to the tarball distribution with kustomize scripts | URL                |          |
| `kustomize.tarball.url`   | Path inside tarball for kustomize scripts              | config/            |          |

## Implementation Details

The component has the following directory structure:
```text
./
├── kustomize                           # target directory to download kserve resources
├── resources                           # Templates to replace existing resources
│      └── istio-patch.yaml.gotemplate
├── hub-component.yaml                  # hub manifest file
└──kustomization.yaml.template          # template for kustomize script to drive main deployment
```

Deployment follows to the following algorithm:
2. At the beginning hubctl will download KServe resources described in parameter `kustomize.resources` to the `./kustomize` directoryl.
3. `pre-deploy` script will use `kserve.deploymentMode` to add correspoining kustomize overlay
4. Then start deployment

## See also

* KServe Service Mesh: <https://kserve.github.io/website/0.10/admin/serverless/servicemesh/>
