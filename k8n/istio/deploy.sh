#!/usr/bin/env bash

kubectl apply -f src/install/kubernetes/helm/istio/templates/crds.yaml

kubectl apply -f src/install/kubernetes/helm/istio/charts/certmanager/templates/crds.yaml

helm template src/install/kubernetes/helm/istio --set gateways.istio-ingressgateway.type=NodePort --set gateways.istio-egressgateway.type=NodePort --name istio --namespace istio-system > istio.yml

kubectl apply -f ./istio.yml

kubectl label namespace default istio-injection=enabled

kubectl apply -f src/samples/bookinfo/platform/kube/bookinfo.yaml

kubectl apply -f src/samples/bookinfo/networking/bookinfo-gateway.yaml

kubectl apply -f src/samples/bookinfo/networking/destination-rule-all.yaml
