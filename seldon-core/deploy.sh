#!/bin/sh -x

echo "Deploying $COMPONENT_NAME..."

if test -z "$DOMAIN_NAME" -o -z "$NAMESPACE"; then
    echo "COMPONENT_NAME, DOMAIN_NAME, NAMESPACE, must be set"
    exit 1
fi

if test -z "$COMPONENT_NAME"; then
  COMPONENT_NAME="$(basename "$(dirname "$0")")"
  echo "* Using chart name: $COMPONENT_NAME"
fi

if test ! -f $HELM_CHART; then
  echo "Error: cannot find file $HELM_CHART"
  exit 2
fi

helm3=helm
if which helm3 >/dev/null; then helm3=helm3; fi

export kubectl="kubectl --context=$DOMAIN_NAME --namespace=$NAMESPACE"
export helm="$helm3 --kube-context=$DOMAIN_NAME --namespace=$NAMESPACE"

if $helm list --failed --pending -q | grep -E "^$COMPONENT_NAME\$"; then
  echo "* Uninstalling $COMPONENT_NAME due to: incomplete deployment"
	$helm uninstall "$COMPONENT_NAME"
fi

for v in values.yaml values-*.yaml; do
  if test -f "$v"; then 
    HELM_OPTS="$HELM_OPTS --values $v"; 
  fi
done

# $helm upgrade "$COMPONENT_NAME-init" "charts/seldon-core-crd-0.2.7.tgz" \
#   --install --create-namespace --wait

$kubectl label namespace "$NAMESPACE" "serving.kubeflow.org/inferenceservice=enabled" --overwrite
$kubectl apply -f "istio-gateway.yaml"

# shellcheck disable=SC2086
$helm upgrade "$COMPONENT_NAME" "charts/seldon-core-operator-1.5.0.tgz" \
  --install --create-namespace --wait $HELM_OPTS
