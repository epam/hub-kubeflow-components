# KServe

KServe is a Kubernetes based platform to deploy your machine learning models on a production ready inference server. It provides a simple Kubernetes CRD based high level abstractions to build secure, scalable and highly available inference services with GPU or CPU based triton inference servers, transformers, pytorch, sklearn/xgboost and custom model servers.

KServe can optionally use knative to provide auto-scaling, traffic routing and canary rollout for inference services.

## Requirements

* [kustomize](https://kustomize.io)

## Dependencies

* Cert Manager
* Istio (requried for Serverless mode)
* Knative-Serving (required for Serverless mode)

## Parameters
 
The following component level parameters has been defined `hub-component.yaml`:

| Name      | Description | Default Value | Required
| --------- | ---------   | ---------     | :---: |
| `kserve.namespace` | Target Kubernetes namespace for this component | `kserve` | `x`
| `kserve.version` | Version of the applicaiton | `v0.10.0` | `x`
| `kserve.deploymentMode` | Currently supported `Serverless` or `RawDeployment` | `RawDeployment` | `x`
| `ingress.class` | Kubernetes ingress class to configure ingress traffic | | |
| `ingress.protocol` | Ingress traffic protocol (schema) | `http` | |
| `ingress.hosts` | List of ingress hosts (Note: only first will be used) | | |
| `bucket.endpoint` | Default bucket configuration | | |
| `bucket.region` | Default bucket region| | |
| `kustomize.resources` | List of kserve resources to be downloaded and installed as part of kustomize script | URL | `x` |

## Implementation Details

Deployment of this components follows deployment described here: <https://kserve.github.io/website/0.10/admin/serverless/serverless/> 

This component has been operated by `kustomize` hubctl extension and have the following directory structure

```text
./
├── kustomize                         # target directory to download kserve resources
├── rawdeployment                     # overlay for RawDeployment kserve deployment mode
│   └── kustomization.yaml.template
├── serverless                        # overlay for Serverless kserve 
│   └── kustomization.yaml.template
├── hub-component.yaml                # hub manifest file
├── kustomization.yaml.template       # template for kustomize script to drive main deployment
├── pre-deploy                        # adds overlays to kustomize.yaml
└── post-undeploy -> pre-deploy       # simlink to support undeploy
```

Deployment follows to the following algorithm:

1. At the beginning hubctl will download KServe resources described in parameter `kustomize.resources` to the `./kustomize` directoryl. 
2. `pre-deploy` script will use `kserve.deploymentMode` to add correspoining kustomize overlay
3. Then start kustomize deployment

## Inference Service config

Inference service behavior has been configured via `inferenceservice-config` configmap patch in kustomization file template.

See configurtion options [here](https://github.com/kserve/kserve/blob/master/config/configmap/inferenceservice.yaml)

## See also

* KServe Service Mesh: <https://kserve.github.io/website/0.10/admin/serverless/servicemesh/>
* Istio: <https://istio.io/latest/docs/setup/getting-started/>
* Cert Manager: <https://cert-manager.io/docs/installation/kubernetes/>
* Knative: <https://knative.dev/docs/>
