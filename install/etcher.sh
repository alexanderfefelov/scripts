#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=1.5.109
readonly STUFF=balenaEtcher-$VERSION-x64.AppImage

mkdir --parents $HOME/bin
wget --quiet --output-document=$HOME/bin/etcher https://github.com/balena-io/etcher/releases/download/v$VERSION/$STUFF
chmod +x $HOME/bin/etcher
