# KServe

KServe is a Kubernetes based platform to deploy your machine learning models on a production ready inference server. It
provides a simple Kubernetes CRD based high level abstractions to build secure, scalable and highly available inference
services with GPU or CPU based triton inference servers, transformers, pytorch, sklearn/xgboost and custom model
servers.

KServe can optionally use knative to provide auto-scaling, traffic routing and canary rollout for inference services.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml`file

```yaml
components:
  - name: kserve
    source:
      dir: components/kserve
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kserve
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration 
hubctl stack deploy -c kserve
```

## Requirements

- [Helm](https://helm.sh/docs/intro/install/)
- Kubernetes
- [Kustomize](https://kustomize.io)
- [Cert Manager](https://github.com/epam/hub-kubeflow-components/tree/develop/cert-manager)
- Istio (required for Serverless mode)
- [Knative-Serving](https://github.com/epam/hub-kubeflow-components/tree/develop/knative-serving): (required for
  Serverless mode)

## Parameters

| Name                    | Description                                                                         | Default Value   | Required |
|-------------------------|-------------------------------------------------------------------------------------|-----------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component                                      | `kserve`        |   `x`    |
| `kserve.version`        | Version of the application                                                          | `v0.10.0`       |   `x`    |
| `kserve.deploymentMode` | Currently supported `Serverless` or `RawDeployment`                                 | `RawDeployment` |   `x`    |
| `ingress.class`         | Kubernetes ingress class to configure ingress traffic                               |                 |          |
| `ingress.protocol`      | Ingress traffic protocol (schema)                                                   | `http`          |          |
| `ingress.hosts`         | List of ingress hosts (Note: only first will be used)                               |                 |          |
| `bucket.endpoint`       | Default bucket configuration                                                        |                 |          |
| `bucket.region`         | Default bucket region                                                               |                 |          |
| `kustomize.resources`   | List of kserve resources to be downloaded and installed as part of kustomize script | URL             |   `x`    |

## Implementation Details

```text
./
├── kustomize                         # target directory to download kserve resources
├── rawdeployment                     # overlay for RawDeployment kserve deployment mode
│      └── kustomization.yaml.template
├── serverless                        # overlay for Serverless kserve 
│      └── kustomization.yaml.template
├── hub-component.yaml                # hub manifest file
├── kustomization.yaml.template       # template for kustomize script to drive main deployment
├── pre-deploy                        # adds overlays to kustomize.yaml
└── post-undeploy -> pre-deploy       # symlink to support undeploy
```

Deployment follows to the following algorithm:

1. Deployment of this component follows deployment described
   here: <https://kserve.github.io/website/0.10/admin/serverless/serverless/>
2. This component has been operated by `kustomize` hubctl extension and have the following directory structure the
   beginning hubctl will download KServe resources described in parameter `kustomize.resources` to the `./kustomize`
   directory.
3. `pre-deploy` script will use `kserve.deploymentMode` to add corresponding kustomize overlay
4. Then start deployment

## Inference Service config

Inference service behavior has been configured via `inferenceservice-config` configmap patch in kustomization file
template.
See configuration options [here](https://github.com/kserve/kserve/blob/master/config/configmap/inferenceservice.yaml)

## See also

* KServe Service Mesh: <https://kserve.github.io/website/0.10/admin/serverless/servicemesh/>
* Istio: <https://istio.io/latest/docs/setup/getting-started/>
* Cert Manager: <https://cert-manager.io/docs/installation/kubernetes/>
* Knative: <https://knative.dev/docs/>
