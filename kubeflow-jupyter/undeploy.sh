#!/bin/sh -e
kubectl="kubectl -n $NAMESPACE --context=$HUB_DOMAIN_NAME"

files download-tar "$URL" "jupyter-web-app/kustomize" --tar-subpath "jupyter/jupyter-web-app"
files download-tar "$URL" "notebook-controller/kustomize" --tar-subpath "jupyter/notebook-controller"

$kubectl delete -k "notebook-controller"
$kubectl delete -k "jupyter-web-app"
