#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

readonly VERSION=3.003
readonly TARGET_DIR=/usr/share/fonts/truetype/hack

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR
  wget --quiet https://github.com/source-foundry/Hack/releases/download/v$VERSION/Hack-v$VERSION-ttf.zip
  unzip -qq Hack-v$VERSION-ttf.zip
  mkdir --parents $TARGET_DIR
  mv --force ttf/* $TARGET_DIR
)
rm --recursive --force $TEMP_DIR

fc-cache
