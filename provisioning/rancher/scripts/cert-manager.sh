#!/usr/bin/env bash

source ../.env

helm install stable/cert-manager --name cert-manager --namespace kube-system

kubectl apply -f config/cert-manager/issuers.yml
kubectl apply -f config/cert-manager/certificates.yml
