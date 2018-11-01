#!/bin/sh
set -e

export DOCKER_OPTS="--iptables=false --ip-masq=false"

apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y docker.io
#apt-get install -y kubeadm=1.11\* kubectl=1.11\* kubelet=1.11\* kubernetes-cni=0.6\*
apt-get install -y kubeadm kubectl kubelet kubernetes-cni=0.6\*
apt-mark hold kubelet kubeadm kubectl kubernetes-cni
