# Kubeflow Kserve

KServe enables serverless inferencing on Kubernetes and provides performant, high abstraction interfaces for common
machine learning (ML) frameworks like TensorFlow, XGBoost, scikit-learn, PyTorch, and ONNX to solve production model
serving use cases.

## TL;DR

Declare hubctl stack with

```shell
cat << EOF > hub.yaml
version: 1
kind: stack

requires:
  - aws
  - kubernetes
  
components:  
  - name: kubeflow-kserve
    source:
      dir: components/kubeflow-kserve
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: kubeflow-kserve 
EOF

hubctl stack init
hubctl stack deploy
```

## Requirements

- Kubernetes
- [kustomize](https://kustomize.io) CLI

## Parameters

The following component level parameters has been defined `hub-component.yaml`:

| Name                         | Description                                    | Default Value                         | Required 
|------------------------------|------------------------------------------------|---------------------------------------|:--------:|
| `dns.domain`                 | Domain name of the kubeflow stack              |                                       |
| `kubernetes.namespace`       | Target Kubernetes namespace for this component | `kubeflow`                            |          |
| `kserve.modelmesh.namespace` | Target Kubernetes namespace for model-mesh     | `kubeflow`                            |          |
| `kserve.version`             | Version of Kserve                              | `v0.8.0`                              |          |
| `etcd.endpoint`              | Etcd endpoint                                  | `http://etcd:2379`                    |          |
| `bucket.endpoint`            | Bucket endpoint                                | `http://minio.kubeflow-data.svc:9000` |          |
| `bucket.region`              | Bucket region                                  | `us-east-1`                           |          |
| `bucket.accessKey`           | Bucket accessKey                               |                                       |          |
| `bucket.secretKey`           | Bucket secretKey                               |                                       |          |
| `bucket.name`                | Bucket name                                    | `mlpipelines`                         |          |

## Implementation Details

This component will deploy three services of the KServe

* [model-mesh](model-mesh) - a web application
* [web-app](web-app) - a BFF (backend-for-frontend) of this applicaiton.
* [web-app2](web-app2) - a BFF (backend-for-frontend) of this applicaiton.

The component has the following directory structure:

```text
./
├── model-mesh                              # Model mesh
│   └── kustomization.yaml.template         # Kustomize script for Model mesh
├── no-certs                                # Delete patch
│   ├── certificate.yaml                    # Kustomize patch to delete certificate
│   └── issuer.yaml                         # Kustomize patch to delete issuer
├── web-app                                 # Backend for UI and operator for Web app
│   └── kustomization.yaml.template         # Kustomize script for Web app
├── web-app2                                # Backend for UI and operator for Notebooks
│   └── kustomization.yaml.template         # Kustomize script for Notebook
├── kustomization.yaml.template             # Main kustomize template file
├── README.md                                   
├── hub-component.yaml                      # Hub manifest
├── post-deploy                             # Pre-deploy script
├── post-undeploy -> pre-undeploy           # simlink to support undeploy
├── pre-deploy                              # Pre-undeploy script
└── pre-undeploy -> pre-deploy              # simlink to support undeploy
```

The component uses an official Kubeflow distribution Kustomize [scripts]("https://github.com/kubeflow/manifests/") as a
and applies patches and additional resources described in [kustomize.yaml](kustomize.yaml.template) file.

## See Also

* Kserve [Documentation](https://kserve.github.io/website/0.11/)
* Kubeflow [KServe](https://www.kubeflow.org/docs/external-add-ons/kserve/kserve/)
