#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=12.1.2
readonly STUFF=tokei-x86_64-unknown-linux-gnu.tar.gz

wget --quiet \
  https://github.com/XAMPPRocky/tokei/releases/download/v$VERSION/$STUFF \
  --output-document=- \
| tar --extract --gunzip --directory=$HOME/bin
