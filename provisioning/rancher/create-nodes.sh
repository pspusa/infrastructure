#!/usr/bin/env bash
set -x

# source the env file - it should contain a VULTR_API_KEY
. ./.env
export VULTR_API_KEY=$VULTR_API_KEY


# verify vultr is installed and available
command -v vultr >/dev/null 2>&1 || {
	echo >&2 "Vultr binary appears to be missing. Please install from https://jamesclonk.github.io/vultr and try again.";
	open https://jamesclonk.github.io/vultr/;
	exit 1;
}


COUNT=3
CLUSTER_ENV=prod
PREFIX="dal-$CLUSTER_ENV"
REGION=3 # Dallas
PLAN=203 # 4096 MB RAM / 60 GB SSD / $20.00/mo
OS=159 # Custom OS - must be 159 to use IPXE
#OS=215 # Ubuntu 16.04 x64
#IPXE_SCRIPT=325538 # rancher-agentless-slave
IPXE_SCRIPT=351346 # rancher-agentless-slave
#SSHKEYID=5b3e8e837146e

TAG=$PREFIX-k8n-cluster
NODES=()

rm -rf ./logs

mkdir logs

for i in {1..3}; do
	vultr server create -n $PREFIX-$i --hostname $PREFIX-$i -r $REGION -p $PLAN -s $IPXE_SCRIPT -o $OS --tag $PREFIX-k8n-cluster >> logs/vultr-create-results.txt
  #vultr server create -n $PREFIX-0$i --hostname $PREFIX-$i -k $SSHKEYID -r $REGION -p $PLAN --private-networking=true -o $OS --tag $PREFIX-k8n-cluster >> logs/vultr-create-results.txt
done

echo "Pausing for 120 seconds to let vultr create new VMs..."
sleep 120
