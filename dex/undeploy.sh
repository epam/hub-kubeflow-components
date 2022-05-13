#!/bin/sh -e
echo "Undeploying $COMPONENT_NAME..."
kubectl="kubectl --context=$DOMAIN_NAME --namespace=$NAMESPACE --ignore-not-found=true"

$kubectl delete -f kubernetes/auth-operator.yaml
$kubectl delete -f kubernetes/service.yaml
$kubectl delete -f kubernetes/service-api.yaml
$kubectl delete -f kubernetes/deployment.yaml
$kubectl delete -f kubernetes/dex-rbac.yaml
$kubectl delete -f kubernetes/grpc-client-secret.yaml
$kubectl delete -f kubernetes/grpc-server-secret.yaml
$kubectl delete -f kubernetes/configmap.yaml
if test  "$INGRESS_PROTOCOL" = "https"; then
  $kubectl delete -f kubernetes/ingress-tls.yaml
else
  $kubectl delete -f kubernetes/ingress.yaml
fi

echo "Done!"
