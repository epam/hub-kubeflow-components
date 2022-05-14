#!/bin/sh -e
kubectl="kubectl -n $NAMESPACE --context=$HUB_DOMAIN_NAME"

files download-tar "$URL" "jupyter-web-app/kustomize" --tar-subpath "jupyter/jupyter-web-app"
files download-tar "$URL" "notebook-controller/kustomize" --tar-subpath "jupyter/notebook-controller"

$kubectl delete --ignore-not-found=true -k "notebook-controller"
$kubectl delete --ignore-not-found=true -k "jupyter-web-app"
