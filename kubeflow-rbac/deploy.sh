#!/bin/sh -e
kubectl="$(which kubectl) --context=$DOMAIN_NAME"
$kubectl apply -f "seldon-edit.yaml"
echo "Done"
