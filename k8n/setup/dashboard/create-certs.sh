#!/usr/bin/env bash
set -e

cd certs
openssl genrsa -des3 -passout pass:x -out dashboard.pass.key 2048
openssl rsa -passin pass:x -in dashboard.pass.key -out dashboard.key

# Writing RSA key
rm dashboard.pass.key
openssl req -new -key dashboard.key -out dashboard.csr -subj '/CN=k8n.psplabs.org/O=Perspectives Study Program./C=US'
openssl x509 -req -sha256 -days 365 -in dashboard.csr -signkey dashboard.key -out dashboard.crt

cd ..
kubectl create secret generic kubernetes-dashboard-certs --from-file=./certs/ -n kube-system

#
# openssl genrsa -des3 -passout pass:x -out dashboard.pass.key 2048
# openssl rsa -passin pass:x -in dashboard.pass.key -out dashboard.key
#
# cd certs
#
# # Core CA Key
# openssl genrsa -out ./ca-key.pem 2048
# openssl req -x509 -new -nodes -key ./ca-key.pem -days 10000 -out ./ca.pem -subj '/CN=kube-ca'
#
# # Ingress Key
# openssl genrsa -out ./ingress-key.pem 2048
# openssl req -new -key ./ingress-key.pem -out ./ingress.csr -subj '/CN=rancher.4act.com'
#
# # Sign Ingress Key with CA
# openssl x509 -req -in ./ingress.csr -CA ca.pem -CAkey ./ca-key.pem -CAcreateserial -out ./ingress.pem -days 7200
