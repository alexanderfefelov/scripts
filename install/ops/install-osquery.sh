#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

readonly KEY=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $KEY
echo "deb [arch=amd64] https://pkg.osquery.io/deb deb main" > /etc/apt/sources.list.d/osquery.list
apt-get -qq update
apt-get -qq install osquery
