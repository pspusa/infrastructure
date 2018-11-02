#!/bin/sh
set -e
set -x

cd provisioning/kubernetes/
terraform init
terraform plan
terraform apply -auto-approve

cd ../../k8n/setup/
./deploy.sh
