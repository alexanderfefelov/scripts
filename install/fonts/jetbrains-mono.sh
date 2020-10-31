#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

readonly VERSION=2.200
readonly TARGET_DIR=/usr/share/fonts/truetype/jetbrains-mono

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR
  wget --quiet https://github.com/JetBrains/JetBrainsMono/releases/download/v$VERSION/JetBrainsMono-$VERSION.zip
  unzip -qq JetBrainsMono-$VERSION.zip
  mkdir --parents $TARGET_DIR
  mv --force fonts/ttf/* $TARGET_DIR
)
rm --recursive --force $TEMP_DIR

fc-cache
