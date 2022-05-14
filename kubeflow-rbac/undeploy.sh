#!/bin/sh
kubectl="$(which kubectl) --context=$DOMAIN_NAME"

$kubectl delete --ignore-not-found=true -f "seldon-edit.yaml"
