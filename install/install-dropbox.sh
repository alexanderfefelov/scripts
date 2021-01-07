#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

wget --quiet \
  https://linux.dropbox.com/fedora/rpm-public-key.asc \
  --output-document=- \
| apt-key add -
echo "deb [arch=amd64] http://linux.dropbox.com/ubuntu bionic main" > /etc/apt/sources.list.d/dropbox.list
apt-get -qq update
apt-get -qq install dropbox
