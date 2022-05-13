#!/bin/sh -xe

pwd=$(dirname "$0")

kubectl="kubectl"
if test -n "$DOMAIN_NAME"; then
  kubectl="$kubectl --context=$DOMAIN_NAME"
fi
if test -n "$NAMESPACE"; then
  kubectl="$kubectl --namespace=$NAMESPACE"
fi

if $kubectl get secret "$1"; then
  echo "Secret $1 already exist..."
  exit 0
fi

echo "Generting self signed cert..."
openssl genrsa -out "$pwd/ca.key" 2048
openssl req -x509 -new -nodes -key "$pwd/ca.key" -subj "/CN=$DOMAIN_NAME" -days 10000 -out "$pwd/ca.crt"
openssl genrsa -out "$pwd/server.key" 2048
openssl req -new -key "$pwd/server.key" -out "$pwd/server.csr" -config "$pwd/csr.conf"
openssl x509 -req -in "$pwd/server.csr" -CA "$pwd/ca.crt" -CAkey "$pwd/ca.key" \
  -CAcreateserial -out "$pwd/server.crt" -days 10000 \
  -extensions v3_ext -extfile "$pwd/csr.conf"

$kubectl create secret tls "$1" \
  --key "$pwd/server.key" \
  --cert "$pwd/server.crt"
