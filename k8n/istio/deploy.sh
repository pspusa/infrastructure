#!/usr/bin/env bash

kubectl apply -f install/kubernetes/helm/istio/templates/crds.yaml

kubectl apply -f install/kubernetes/helm/istio/charts/certmanager/templates/crds.yaml

helm template install/kubernetes/helm/istio --name istio --namespace istio-system

