#!/usr/bin/env bash

# Cloudflared Ingress Controller

if [ "$1" == "-r" ] || [ "$1" == "--reset" ]; then

rm $HOME/.cloudflared/cert.pem
helm del --purge argo-tunnel
helm del --purge argo-tunnel-pspusa
helm del --purge argo-tunnel-psplabs

kubectl delete secret argo-tunnel

kubectl delete -f ./cloudflare

fi


helm repo add cloudflare https://cloudflare.github.io/helm-charts
helm repo update

helm install --name argo-tunnel --namespace default \
    --set rbac.create=true \
    --set controller.ingressClass=argo-tunnel \
    --set controller.logLevel=6 \
    --set loadBalancing.enabled=true \
    --set controller.replicaCount=3 \
    cloudflare/argo-tunnel


kubectl -n default apply -f ./cloudflare/echo.yml



if [ ! -f "$HOME/.cloudflared/cert.pem" ]; then

  # Detect the platform (similar to $OSTYPE)
  OS="`uname`"
  case $OS in
    'Linux') OS='linux' ;;
    'WindowsNT') OS='windows' ;;
    'Darwin') OS='darwin' ;;
    *) ;;
  esac

  curl "https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-$OS-amd64.tgz" | tar xzC /usr/local/bin

  cloudflared login

  kubectl create secret generic argo-tunnel --from-file="$HOME/.cloudflared/cert.pem"
  kubectl label secret argo-tunnel "cloudflare-argo/domain=pspusa.app" --overwrite

fi


kubectl -n default apply -f ./cloudflare/echo-tunnel.yml

#kubectl annotate ingress echo "argo.cloudflare.com/lb-pool=prod-pool"

curl http://echo.prod.pspusa.app
curl https://echo.prod.pspusa.app
curl http://echo.pspusa.app
curl https://echo.pspusa.app
