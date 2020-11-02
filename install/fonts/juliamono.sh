#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

readonly VERSION=0.025
readonly STUFF=JuliaMono.zip

readonly TARGET_DIR=/usr/share/fonts/truetype/juliamono
mkdir --parents $TARGET_DIR

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR
  wget --quiet https://github.com/cormullion/juliamono/releases/download/v$VERSION/$STUFF
  unzip -qq $STUFF
  mv --force *.ttf $TARGET_DIR
)
rm --recursive --force $TEMP_DIR

fc-cache
