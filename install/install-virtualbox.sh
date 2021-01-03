#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

wget --quiet https://www.virtualbox.org/download/oracle_vbox_2016.asc --output-document=- | apt-key add -
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian focal contrib" > /etc/apt/sources.list.d/virtualbox.list
apt-get -qq update
apt-get -qq install virtualbox
