#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

wget --quiet \
  https://packages.cloud.google.com/apt/doc/apt-key.gpg \
  --output-document=- \
| apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/dropbox.list
apt-get -qq update
apt-get -qq install kubectl
