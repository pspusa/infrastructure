#!/usr/bin/env bash


function deploy_controller {
  NODES=$(kubectl get node | grep worker | grep controlplane | grep -o "^[\.0-9]*\S")
  for n in $NODES; do
    echo "Applying label 'role=ingress-controller' to node: $n"
    kubectl label node $n role=ingress-controller --overwrite
  done


  kubectl apply -f ./haproxy-ingress.yaml
}


function generate_secret {
  if [ ! -f ./secrets.yml ]; then
  cat <<EOF > secrets.yml
apiVersion: v1
kind: Secret
metadata:
  name: ingress-secrets
data:
  COOKIE_SECRET: $(dd if=/dev/urandom of=/dev/stdout bs=16 count=1 2>/dev/null|base64)
EOF
fi
  kubectl apply -f ./secrets.yml
}

function deploy_oauth_proxy {
  generate_secret
  kubectl apply -f ./oauth2-proxy.yaml

}

deploy_controller

deploy_oauth_proxy

kubectl run echoserver \
--image=gcr.io/google_containers/echoserver:1.3 \
--port=8080 \
--expose

kubectl apply -f test-app.yml
