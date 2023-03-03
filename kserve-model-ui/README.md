# Model UI

Web app for managing Model servers
The Models web app is responsible for allowing the user to manipulate the Model Servers in their Kubeflow cluster. To achieve this it provides a user friendly way to handle the lifecycle of `InferenceService` CRs.

The web app currently works with v1beta1 versions of InferenceService objects.

The web app is also exposing information from the underlying Knative resources, like Conditions from the Knative Configurations, Route and Revisions as well as live logs from the Model server pod.


## Parameters

The following component level parameters has been defined `hub-component.yaml`


| Name | Description | Default Value |
| :--- | :---        | :---          |
| `kserve.version` | Kserve version | `v1.9.2` |

## Limitations

The web app currently works with `v1beta1` versions of `InferenceService` objects.

