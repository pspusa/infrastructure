#!/usr/bin/env bash

docker stop nuster && docker rm nuster

docker pull nuster/nuster
docker run -d \
  -v /app/pspusa/infrastructure/nuster/nuster.cfg:/etc/nuster/nuster.cfg \
  -v /app/pspusa/infrastructure/nuster/certs/perspectives.org.pem:/etc/haproxy/perspectives.org.pem \
  -p 80:80 \
  -p 443:443 \
  -p 3389:3389 \
  -p 1433:1433 \
  -p 8080:8080 \
  -p 8081:8081 \
  --name nuster \
  nuster/nuster

docker logs nuster
