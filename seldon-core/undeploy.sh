#!/bin/sh

if test -z "$DOMAIN_NAME" -o -z "$NAMESPACE"; then
    echo "COMPONENT_NAME, DOMAIN_NAME, NAMESPACE must be set"
    exit 1
fi

if test -z "$COMPONENT_NAME"; then
  COMPONENT_NAME="$(basename "$(dirname "$0")")"
  echo "* Using chart name: $COMPONENT_NAME"
fi

helm3=helm
if which helm3 >/dev/null; then helm3=helm3; fi

export kubectl="kubectl --context=$DOMAIN_NAME --namespace=$NAMESPACE"
export helm="$helm3 --kube-context=$DOMAIN_NAME --namespace=$NAMESPACE"

if $helm list --deployed --failed --pending -q | grep -E "^$COMPONENT_NAME\$"; then
  set -x
  $helm uninstall "$COMPONENT_NAME"
  $kubectl delete -f istio-gateway.yaml
fi
