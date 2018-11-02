#!/bin/sh
set -e
set -x

cd provisioning/kubernetes/
terraform destroy --auto-approve --force
