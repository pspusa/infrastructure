#!/bin/sh
set -e

scp -oStrictHostKeyChecking=no \
  root@${element(var.connections, 0)}:/etc/kubernetes/pki/{apiserver-kubelet-client.key,apiserver-kubelet-client.crt,ca.crt} \
  $HOME/.kube/${var.cluster_name}
