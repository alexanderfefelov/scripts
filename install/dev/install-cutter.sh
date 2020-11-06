#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=cutter
readonly VERSION=1.12.0
readonly STUFF=Cutter-v$VERSION-x64.Linux.AppImage
readonly TARGET_DIR=$HOME/bin

mkdir --parents $HOME/bin
wget --quiet --output-document=$TARGET_DIR/$MONIKER https://github.com/radareorg/cutter/releases/download/v$VERSION/$STUFF
chmod +x $TARGET_DIR/$MONIKER
