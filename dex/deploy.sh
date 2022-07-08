#!/bin/sh -ex
kubectl="$(which kubectl) --context=$DOMAIN_NAME --namespace=$NAMESPACE"

if ! $kubectl get namespace "$NAMESPACE" > /dev/null; then 
  $kubectl create namespace "$NAMESPACE"
fi

$kubectl apply -f kubernetes/grpc-client-secret.yaml
$kubectl apply -f kubernetes/grpc-server-secret.yaml

$kubectl apply -f kubernetes/crd/oidc.yaml
$kubectl apply -f kubernetes/crd/authcodes.yaml
$kubectl apply -f kubernetes/crd/authrequests.yaml
$kubectl apply -f kubernetes/crd/connectors.yaml
$kubectl apply -f kubernetes/crd/devicerequests.yaml
$kubectl apply -f kubernetes/crd/devicetokens.yaml
$kubectl apply -f kubernetes/crd/oauth2clients.yaml
$kubectl apply -f kubernetes/crd/offlinesessionses.yaml
$kubectl apply -f kubernetes/crd/passwords.yaml
$kubectl apply -f kubernetes/crd/refreshtokens.yaml
$kubectl apply -f kubernetes/crd/signingkeies.yaml

$kubectl apply -f kubernetes/dex-rbac.yaml
$kubectl get configmap dex || $kubectl apply -f kubernetes/configmap.yaml
$kubectl apply -f kubernetes/deployment.yaml
$kubectl apply -f kubernetes/service.yaml
$kubectl apply -f kubernetes/service-api.yaml
if test  "$INGRESS_PROTOCOL" = "https"; then
  $kubectl apply -f kubernetes/ingress-tls.yaml
else
  $kubectl apply -f kubernetes/ingress.yaml
fi
$kubectl apply -f kubernetes/auth-operator.yaml
