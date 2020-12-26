#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=0.7.1
readonly STUFF=mcrcon-$VERSION-linux-x86-64.tar.gz

wget --quiet \
  https://github.com/Tiiffi/mcrcon/releases/download/v$VERSION/$STUFF \
  --output-document=- \
  | tar --extract --gunzip --directory=$HOME/bin --strip-components 1 mcrcon-$VERSION-linux-x86-64/mcrcon
