#!/bin/bash
set -x

#TAG=$1
NODES=$(grep -o '^[0-9]\+' logs/vultr-create-results.txt)
echo $NODES

echo "Writing new nodes to nodes.yml"
echo "nodes:" > config/nodes.yml

for node in ${NODES[@]}; do

	DETAILS=$(vultr server show $node)

	IP=$(echo "$DETAILS" | grep '^IP:' | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')

	ssh -oStrictHostKeyChecking=accept-new -i ~/.ssh/id_rsa rancher@$IP -t 'sudo whoami' > /dev/null 2>&1

	NAME=$(echo "$DETAILS" | grep 'Name:\s\+' | grep -o '\S*$')

	cat <<EOF >> config/nodes.yml
  - address: $IP
    user: rancher
    ssh_key_path: ~/.ssh/id_rsa
    role: [controlplane,worker,etcd]
EOF

done
