#!/bin/sh
set -e

kubeadm init --config /tmp/master-configuration.yml \
  --ignore-preflight-errors=Swap

kubeadm token create ${token}

[ -d $HOME/.kube ] || mkdir -p $HOME/.kube
ln -s /etc/kubernetes/admin.conf $HOME/.kube/config

kubectl taint nodes --all node-role.kubernetes.io/master-

until $(curl --output /dev/null --silent --head --fail http://localhost:6443); do
  echo "Waiting for API server to respond"
  sleep 5
done

sysctl net.bridge.bridge-nf-call-iptables=1
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.32.0.0/13"

# See: https://kubernetes.io/docs/admin/authorization/rbac/
kubectl create clusterrolebinding permissive-binding \
  --clusterrole=cluster-admin \
  --user=admin \
  --user=kubelet \
  --group=system:serviceaccounts
