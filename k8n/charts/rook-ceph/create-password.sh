#!/usr/bin/env bash

#htpasswd -bi admin

kubectl delete secret admin-user -n default

cat <<EOF > secret.yml
apiVersion: v1
kind: Secret
metadata:
  name: admin-user
  namespace: default
data:
  password: $(htpasswd -n admin | base64)
type: Opaque
EOF
