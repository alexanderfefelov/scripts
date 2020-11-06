#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=etcher
readonly VERSION=1.5.109
readonly STUFF=balenaEtcher-$VERSION-x64.AppImage
readonly TARGET_DIR=$HOME/bin

mkdir --parents $HOME/bin
wget --quiet --output-document=$TARGET_DIR/$MONIKER https://github.com/balena-io/etcher/releases/download/v$VERSION/$STUFF
chmod +x $TARGET_DIR/$MONIKER
