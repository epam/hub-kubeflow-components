# KServe

Highly scalable and standards based Model Inference Platform on Kubernetes for Trusted AI

## Requirements

- Requires [kustomize](https://kustomize.io)

## Implementation Details & Parameters

This component has been operated by `kustomize` hub extension. 

Downloads tarball with base kustomize script and unpacks into the `./kustomize` directory

This is a light version of `kubeflow-kserve` component without dependencies on `etcd`, `istio` and `knative`

```text
./
└── kustomization.yaml                   # Kustomize deployment manifest
```
 
The following component level parameters has been defined `hub-component.yaml`:

| Name      | Description | Default Value
| --------- | ---------   | ---------
| `kserve.namespace` | Target Kubernetes namespace for this component | `kserve`
| `kserve.version`   | Version (branch) of Tensorboard app to be used | `v0.10.0`
| `kustomize.tarball`   | URL to the tarball distribution with kustomize scripts | [tarball](https://github.com/kserve/kserve/archive/refs/tags/v0.10.0.tar.gz) | 
| `kustomize.subpath`   | Path inside tarball for kustomize scripts | [install/v0.10.0](https://github.com/kserve/kserve/tree/master/install/v0.10.0) | 

