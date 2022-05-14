#!/bin/sh -e

kubectl="kubectl -n $NAMESPACE --context=$HUB_DOMAIN_NAME"
if ! $kubectl get "notebooks.kubeflow.org" > /dev/null; then
  $kubectl create -f "crds/notebook.yaml"
fi

files download-tar "$URL" "notebook-controller/kustomize" --tar-subpath "jupyter/notebook-controller"
files download-tar "$URL" "jupyter-web-app/kustomize" --tar-subpath "jupyter/jupyter-web-app"

$kubectl apply -k "notebook-controller"
$kubectl apply -k "jupyter-web-app"

if test -f "$BACKUP_FILE"; then
  set +e
  gunzip -c "$BACKUP_FILE" | $kubectl create -f -
  echo "Done!"
fi
