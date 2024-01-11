#!/bin/bash

# Based on https://kind.sigs.k8s.io/docs/user/quick-start/

# Creates a cluster without the default networking addon because we will use calico 
echo "[INFO] - Creating cluster"
kind create cluster --config=kind-config.yaml
echo "[INFO] - Created cluster"


# installs calico
echo "[INFO] - Installing calico"
kubectl apply -f https://docs.projectcalico.org/v3.25/manifests/calico.yaml
echo "[INFO] - Installed calico"


# Installs metallb
# Reference: https://kind.sigs.k8s.io/docs/user/loadbalancer/

echo "[INFO] - Installing metallb"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
echo "[INFO] - Installed metallb"

echo "[INFO] - Waiting until metallb is ready"
# waits until metallb is ready
kubectl wait --namespace metallb-system \
             --for=condition=ready pod \
             --selector=app=metallb \
             --timeout=90s
echo "[INFO] - metallb is ready"

# find the kind docker network subnet range
DOCKER_SUBNET=$(docker network inspect kind -f '{{range .IPAM.Config}}{{ if (eq 4 (len (split .Subnet "." ))) }}{{ (index (split .Subnet "/") 0 )}}{{end}}{{end}}')

START=$(echo $DOCKER_SUBNET | sed 's/\.0$/.200/')
END=$(echo $DOCKER_SUBNET | sed 's/\.0$/.250/')

echo "[INFO] - Creating resources to setup load balancer"
# create the resources to setup the load balancer
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: example
  namespace: metallb-system
spec:
  addresses:
  - ${START}-${END}
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
EOF
echo "[INFO] - Created resources to setup load balancer"
