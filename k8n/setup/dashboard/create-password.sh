#!/usr/bin/env bash

#htpasswd -bi admin

kubectl delete secret kubernetes-dashboard-auth -n kube-system

cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Secret
metadata:
  name: kubernetes-dashboard-auth
  namespace: kube-system
data:
  auth: $(htpasswd -n admin | base64)
type: Opaque
EOF
