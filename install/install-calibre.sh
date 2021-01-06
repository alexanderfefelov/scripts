#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=calibre
readonly TARGET_DIR=$HOME/programs/$MONIKER

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

wget --quiet --output-document=- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin install_dir=$HOME/programs isolated=y
