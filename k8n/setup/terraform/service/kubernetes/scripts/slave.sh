#!/bin/sh
set -e

until $(nc -z ${master_ip} 6443); do
  echo "Waiting for API server to respond"
  sleep 5
done

sysctl net.bridge.bridge-nf-call-iptables=1
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

kubeadm join --token=${token} ${master_ip}:6443 \
  --discovery-token-unsafe-skip-ca-verification \
  --ignore-preflight-errors=Swap
