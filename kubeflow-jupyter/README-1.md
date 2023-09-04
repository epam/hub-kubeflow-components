# Title

Text description of the component

## TL;DR

```shell

```

## Requirements

List of the tools and software software packages or specific configuration required to deploy this component

Example:
* [helm](https://helm.sh)
* [kustomize](https://kustomize.io)

List of component dependencies (can be other components, or features expected from the environemnt)

Example:
* Kubernetes cluster
* Cert Manager
* Istio

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name      | Description | Default Value | Required
| --------- | ---------   | ---------     | :---: |
| `parameter.name` | Meaning for parameter | `default value` | `x`

### Ouptuts

This component provides the following output values that can be consumed by other components.

| Name | Description |
| :--- | :---        |
| `ouptut.name` | Descripiton |

> Note: Do not add this chapter if component does not produce any outputs

## Implementation Details

Directory content description.

Use following command (example) and paste the result of the command in the text snippet tag
`tree --dirsfirst -L 3 "components/nginx"`

Add following things to the text snippet
- [ ] Remove files generated such as (values.yaml if there is values.yaml.template)
- [ ] Add descripiton to each file prefixed wiht # and format so it would form clean line
- [ ] Avoid meaningless description such `values.yaml # values file`

> Note: parameters with default values have been omited as required parameters

Write a deployment algorithm if applicable.

## Inference Service config

## See also

List of other components or what user should look next