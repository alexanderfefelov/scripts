#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=0.9.6
readonly STUFF=$VERSION

wget --quiet \
  https://github.com/com-lihaoyi/mill/releases/download/$VERSION/$STUFF \
  --output-document=$HOME/bin/mill
chmod +x $HOME/bin/mill
