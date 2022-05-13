#!/bin/sh -e
../../bin/shell/download-manifests -o "$(pwd)/jupyter-web-app/kustomize" -s "jupyter/jupyter-web-app"
../../bin/shell/download-manifests -o "$(pwd)/notebook-controller/kustomize" -s "jupyter/notebook-controller"

kubectl="kubectl -n $NAMESPACE --context=$HUB_DOMAIN_NAME"
kustomize build "notebook-controller" | $kubectl delete -f -
kustomize build "jupyter-web-app" | $kubectl delete -f -
