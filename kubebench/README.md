# Kube-bench

Kube-bench is valuable for organizations that want to ensure that their Kubernetes clusters are configured securely and compliant with industry standards.
By running kube-bench regularly, administrators can identify and address security vulnerabilities and misconfigurations, reducing the risk of security breaches.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml`file

```yaml
components:
  - name: kubebench
    source:
      dir: components/kubebench
      git:
        remote: https://github.com/epam/hub-kubeflow-components.git
        subDir: kubebench
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy kubebench
```

## Requirements

* [Helm](https://helm.sh/docs/intro/install/)
* Kubernetes
* [Kustomize](https://kustomize.io)

## Parameters

| Name                    | Description                                            | Default Value                                                                 |
|-------------------------|--------------------------------------------------------|-------------------------------------------------------------------------------|
| `kubernetes.namespace`  | Target Kubernetes namespace for this component         | `kubeflow`                                                                    |
| `kubebench.version`     | Version (branch) of Tensorboard app to be used         | `v1.5.0`                                                                      |
| `kustomize.tarball.url` | URL to the tarball distribution with kustomize scripts | `https://codeload.github.com/kubeflow/manifests/tar.gz/${kubernetes.version}` |
| `kustomize.subpath`     | Path inside tarball for kustomize scripts              | `apps/kfserving/upstream`                                                     |

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml           # hub manifest file
└── kustomization.yaml.template  # template for kustomize script to drive main deployment
```

Deployment follows to the following algorithm:

1. This component has been operated by `kustomize` hub extension.
2. Downloads tarball with base kustomize script and unpacks into the `./kustomize` directory. Fixing missing in manifests kustomize variable (namespace)
3. Then start deployment

## See also

* [GKE cluster](https://github.com/agilestacks/google-components/tree/main/gke-gcloud)
