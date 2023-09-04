# KFServing

KFServing provides API for inference requests and standardizes ML operations on top of Kubernetes. With the "model as data" approach, KFServing encapsulates the complexity of networking, configuration, autoscaling, health checking, and Canary deployments.

## TLDR

```yaml
  - name: kfserving
    source:
      dir: components/kfserving
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kfserving
```

## Requirements

- Helm
- Kubernetes
- Kustomize
- Knative
- Istio

## Parameters

| Name                    | Description                                            | Default Value                                                                 | Required |
|-------------------------|--------------------------------------------------------|-------------------------------------------------------------------------------|:--------:|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component         | `kubeflow`                                                                    |          |
| `kubernetes.version`    | Version (branch) of Tensorboard app to be used         | `v1.5.0`                                                                      |          |
| `kustomize.tarball.url` | URL to the tarball distribution with kustomize scripts | "https://codeload.github.com/kubeflow/manifests/tar.gz/${kubernetes.version}" |          |
| `kustomize.subpath`     | Path inside tarball for kustomize scripts              | apps/kfserving/upstream                                                       |          |

## Implementation Details

The component has the following directory structure:
```text
./
├── bin
│      └── self-signed-ca.sh            # Hook for generating TLS certificates and keys for a Kubernetes webhook service
├── overrides
│      └── default
             └── kustomization.yaml     # Remove hard dependency on cert-manager
├── hub-component.yaml                  # manifest file of the component with configuration and parameters
├── kustomization.yaml                  # Kustomize deployment manfiet
├── pre-deploy                          # Pre deployment hook
├── post-undeploy                       # Post undeploy hook
└── pre-undeploy -> pre-deploy          # Before deployment hook
```
 
Deployment follows to the following algorithm:
1. The `pre-deploy` script first overrides manifests in a `kustomize` directory by copying the contents of the "overrides" directory. It then checks if a specific Kubernetes Secret exists and, if not, generates a self-signed SSL certificate and stores it in the `.generated` directory. The script performs these actions based on the context and configuration provided in the script.
2. This component has been operated by `kustomize` hub extension. Downloads tarball with base kustomize script and unpacks into the `./kustomize` directory. Fixing missing in manifests kustomize variable (namespace). Kustomize manifest with and remove hard-dependency on the cert-manager
3. Then start deployment

## See also

* [kustomize](https://kustomize.io)
* [External DNS](https://github.com/kubernetes-sigs/external-dns)
* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)
* [hub cli](https://github.com/agilestacks/hub/wiki)