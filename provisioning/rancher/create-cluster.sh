#!/usr/bin/env bash
set -x

indent() { sed 's/^/  /'; }

cat config/nodes.yml config/rke-cluster.yml > cluster.yml

# for f in "./secrets/*.yml"; do
	# echo "  ---" >> cluster.yml
	# cat $f | indent >> cluster.yml
# done

#cat certs/certs.yml | indent >> cluster.yml

rke up --config ./cluster.yml
