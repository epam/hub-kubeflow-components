#!/bin/sh -e

if test -z "$COMPONENT_NAME" -o -z "$DOMAIN_NAME" -o -z "$NAMESPACE"; then
    echo "Error: COMPONENT_NAME, DOMAIN_NAME, NAMESPACE has not been defined"
    exit 1
fi

echo "Deploying $COMPONENT_NAME..."

# mkdir -p ".workdir"
# rsync -aIv "$(pwd)/chart/" ".workdir"
# rsync -aIv "$(pwd)/ext/" ".workdir/templates"

helm3=helm
if which helm3 >/dev/null; then helm3=helm3; fi

kubectl="kubectl --context=$DOMAIN_NAME --namespace=$NAMESPACE"
helm="$helm3 --kube-context=$DOMAIN_NAME --namespace=$NAMESPACE"

if test -n "$HELM_CHART_VERSION"; then
    HELM_OPTS="$HELM_OPTS --version $HELM_CHART_VERSION"
fi

# TODO no HELM_HOME in Helm 3
# https://helm.sh/docs/faq/#xdg-base-directory-support
# Helm stores cache, configuration, and data based on the following configuration order:
# - If a HELM_*_HOME environment variable is set, it will be used
# - Otherwise, on systems supporting the XDG base directory specification, the XDG variables will be used
# - When no other location is set a default location will be used based on the operating system
#export HELM_HOME=$(pwd)/.helm
export kubectl helm

if $helm list --failed --pending -q | grep -E "^$COMPONENT_NAME\$"; then
  echo "* Uninstalling previously deployed: $COMPONENT_NAME"
  set -x
	$helm uninstall "$COMPONENT_NAME"
fi

rm -rf "$HELM_CHART_DIR"
mkdir -p "$HELM_CHART_DIR"
tar -C "$HELM_CHART_DIR" -xzf "$HELM_CHART"

for v in values.yaml values-*.yaml; do
  test -f "$v" || continue
  echo "* Using values from: $v"
  HELM_OPTS="$HELM_OPTS --values $v";
done

# shellcheck disable=SC2086
$helm upgrade \
  "$COMPONENT_NAME" \
  "$HELM_CHART_DIR/istio/charts/gateways" \
  --create-namespace \
  --install \
  --wait $HELM_OPTS

if test -n "$INGRESS_HOST" && ! $kubectl get -f ingress.yaml > /dev/null; then
  $kubectl apply -f ingress.yaml
fi
