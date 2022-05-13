#!/bin/sh -ex
../../bin/shell/download-manifests -o "$(pwd)/jupyter-web-app/kustomize" -s "jupyter/jupyter-web-app"
../../bin/shell/download-manifests -o "$(pwd)/notebook-controller/kustomize" -s "jupyter/notebook-controller"

kubectl="kubectl -n $NAMESPACE --context=$HUB_DOMAIN_NAME"
if ! $kubectl get "notebooks.kubeflow.org" > /dev/null; then
  $kubectl create -f "crds/notebook.yaml"
fi

kustomize build "notebook-controller" | $kubectl apply -f -
kustomize build "jupyter-web-app" | $kubectl apply -f -

if test -f "$BACKUP_FILE"; then
  set +e
  gunzip -c "$BACKUP_FILE" | $kubectl create -f -
  echo "Done!"
fi
