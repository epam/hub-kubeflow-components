# Argo Workflows Component #

## Description

Argo Workflows is an open source container-native workflow engine for orchestrating parallel jobs on Kubernetes. Argo Workflows is implemented as a Kubernetes CRD.

* Define workflows where each step in the workflow is a container.
* Model multi-step workflows as a sequence of tasks or capture the dependencies between tasks using a graph (DAG).
* Easily run compute intensive jobs for machine learning or data processing in a fraction of the time using Argo Workflows on Kubernetes.
* Run CI/CD pipelines natively on Kubernetes without configuring complex software development products.

## Implementation Details & Parameters

The Argo Workflows Component has the following directory structure:

```text
./
├── hub-component.yaml          # configuration and parameters file of Hub component
├── values.yaml.template        # template of Helm's values.yaml file
├── post-deploy                 # script that is executed after deploy of the current component
├── post-undeploy               # script that is executed after undeploy of the current component
├── pre-deploy                  # script that is executed before deploy of the current component
├── charts/                     # directory for Helm Chart sources
├── resources/                  # component custom resource descriptors
└── backup                      # shell script that contains backup routines
```

The component uses an offical [Helm Chart](https://artifacthub.io/packages/helm/argo/argo-workflows/0.9.4) to provision Argo Forkflows.

To make configuration more flexible, ingress object for Argo workflow dashboard and IAM is configured outside the Helm in `post-deploy` script.

The following component level parameters can be set in `hub-component.yaml`:

| Name      | Description | Default Value 
| --------- | ---------   | ---------
| component.argo.namespace       | Kubernetes namespace where Argo is provisioned            | kubeflow
| component.argo.workflowNamespace      | Kubernetes namespace where workflow workloads are created            | kubeflow
| component.argo.workflowRBAC      | Flag that enables k8s Role and RoleBinding creation in the workflowNamespace with required permissions to run workflow workloads            | true
| component.argo.version      | Argo version     | v2.12.3
| component.argo.containerRuntimeExecutor      | Container runtime, read more [here](https://argoproj.github.io/argo-workflows/workflow-executors/)     | k8sapi
| component.argo.helm.chart      | Helm Chart version    | argo-workflows-0.9.4.tgz

## Dependencies

Argo Component does not depend on any other component in the stack

## References

* [Argo Workflows](https://argoproj.github.io/argo-workflows/)
* [Helm](https://helm.sh/docs/intro/install/)

