#!/bin/bash
set -eo pipefail

INGRESS_NAME=$1
HOST_LINE=$(kubectl get ing "$INGRESS_NAME" -o=jsonpath='{.status.loadBalancer.ingress[0].ip} {" "} {.spec.rules[0].host}')

if [ -z "$HOST_LINE" ]; then
  echo "$INGRESS_NAME not found"
  exit 1
fi
if ! grep -q "$HOST_LINE" /etc/hosts; then
  sudo sh -c "echo $HOST_LINE >> /etc/hosts"
else
  echo "Entry already added"
fi