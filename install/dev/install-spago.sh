#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=0.20.3
readonly STUFF=Linux.tar.gz

wget --quiet \
  https://github.com/purescript/spago/releases/download/$VERSION/$STUFF \
  --output-document=- \
| tar --extract --gunzip --directory=$HOME/bin
