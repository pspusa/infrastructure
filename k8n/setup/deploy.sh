#!/bin/sh
set -e
set -x

kubectl apply -f ./helm
helm init --service-account tiller

kubectl apply -f ./ingress
kubectl apply -f ./ingress/tls

./dashboard/create-password.sh
kubectl apply -f ./dashboard
