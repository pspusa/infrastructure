#!/usr/bin/env bash

curl -sSL https://rexray.io/install | sh -s -- stable

cat <<EOF >/etc/rexray/config.yml
libstorage:
  # The libstorage.service property directs a libStorage client to direct its
  # requests to the given service by default. It is not used by the server.
  integration:
    volume:
      operations:
        mount:
          preempt: true
  service: s3fs
  server:
    services:
      s3fs:
        driver: s3fs
        s3fs:
          accessKey: ${rexray_s3_accesskey}
          secretKey: ${rexray_s3_secret}
          endpoint: ${rexray_s3_url}
          options: "allow_other,use_path_request_style,nonempty,url=${rexray_s3_url}"

s3fs:
  accessKey: ${rexray_s3_accesskey}
  secretKey: ${rexray_s3_secret}
  endpoint: ${rexray_s3_url}
  options: "allow_other,use_path_request_style,nonempty,url=${rexray_s3_url}"

EOF

rexray volume ls





rexray flexrex install
systemctl restart kubelet
