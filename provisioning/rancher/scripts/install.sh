#!/usr/bin/env bash

cp ./kube_config_cluster.yml ~/.kube/config

kubectl apply -f config/helm.yml

helm init --service-account tiller

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

sleep 20

./cert-manager.sh

helm install rancher-latest/rancher \
  --name rancher \
  --namespace cattle-system \
  --set hostname=$RANCHER_HOSTNAME \
  --set ingress.tls.source=${INGRESS_TLS_SOURCE:-letsEncrypt} \
  --set letsEncrypt.email=${LETSENCRYPT_EMAIL:-daniel.bodnar@perspectives.org}
