#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

apt-get -qq update
apt-get -qq install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common
curl --silent --show-error --location https://download.docker.com/linux/ubuntu/gpg | apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" > /etc/apt/sources.list.d/docker.list
apt-get -qq update
apt-get -qq install \
  docker-ce \
  docker-ce-cli \
  containerd.io
echo '{
  "data-root": "/var/lib/docker",
  "features": {
    "buildkit": true
  }
}' > /etc/docker/daemon.json
