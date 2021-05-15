#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=2.3.0
readonly STUFF=hadolint-Linux-x86_64

wget --quiet \
  https://github.com/hadolint/hadolint/releases/download/v$VERSION/$STUFF \
  --output-document=$HOME/bin/hadolint
chmod +x $HOME/bin/hadolint
