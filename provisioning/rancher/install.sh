#!/usr/bin/env bash

cp ./kube_config_cluster.yml ~/.kube/config

kubectl -n kube-system create serviceaccount tiller


kubectl create clusterrolebinding tiller \
  --clusterrole cluster-admin \
  --serviceaccount=kube-system:tiller

helm init --service-account tiller

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

sleep 20

helm install stable/cert-manager --name cert-manager --namespace kube-system

helm install rancher-latest/rancher \
  --name rancher \
  --namespace cattle-system \
  --set hostname=rancher.psplabs.org \
  --set ingress.tls.source=letsEncrypt \
  --set letsEncrypt.email=daniel.bodnar@perspectives.org
