#!/usr/bin/env bash
pharmer create cluster psp-dev \
	--provider=vultr \
	--zone=3 \
	--nodes=203=2 \
	--credential-uid=vul \
	--kubernetes-version=v1.12

pharmer apply psp-dev
