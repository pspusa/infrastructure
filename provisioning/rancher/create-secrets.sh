#!/usr/bin/env bash
set -e
source ./.env

kubectl create secret generic cert-manager-secrets --from-literal=CLOUDFLARE_TOKEN=$CLOUDFLARE_TOKEN
