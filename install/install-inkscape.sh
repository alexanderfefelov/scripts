#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

add-apt-repository --yes ppa:inkscape.dev/stable-1.1
apt-get -qq update
apt-get -qq install inkscape-trunk
