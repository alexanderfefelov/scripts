#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  wget --quiet https://linux.dropbox.com/fedora/rpm-public-key.asc
  apt-key add rpm-public-key.asc
  echo "deb [arch=amd64] http://linux.dropbox.com/ubuntu bionic main" > /etc/apt/sources.list.d/dropbox.list
  apt-get -qq update
  apt-get -qq install dropbox
)
rm --recursive --force $TEMP_DIR
