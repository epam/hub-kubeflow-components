# Kube-bench

Kube-bench is valuable for organizations that want to ensure that their Kubernetes clusters are configured securely and compliant with industry standards. By running kube-bench regularly, administrators can identify and address security vulnerabilities and misconfigurations, reducing the risk of security breaches.

## TLDR

```yaml
  - name: kubebench
    source:
      dir: components/kubebench
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubebench
```

## Requirements

- Helm
- Kubernetes
- Kustomize

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
├── hub-component.yaml                  # hub manifest file
└── kustomization.yaml                  # template for kustomize script to drive main deployment
```

Deployment follows to the following algorithm:
1. This component has been operated by `kustomize` hub extension.
2. Downloads tarball with base kustomize script and unpacks into the `./kustomize` directory. Fixing missing in manifests kustomize variable (namespace)
3. Then start deployment

## See also

* [kustomize](https://kustomize.io)
* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)
* [hub cli](https://github.com/agilestacks/hub/wiki)