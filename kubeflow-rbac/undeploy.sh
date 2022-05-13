#!/bin/sh
kubectl="$(which kubectl) --context=$DOMAIN_NAME"

set +e
$kubectl delete -f "seldon-edit.yaml"

echo "Done!"
