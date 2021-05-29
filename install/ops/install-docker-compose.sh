#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=1.29.2
readonly STUFF=docker-compose-Linux-x86_64

wget --quiet --output-document=$HOME/bin/docker-compose https://github.com/docker/compose/releases/download/$VERSION/$STUFF
chmod +x $HOME/bin/docker-compose
