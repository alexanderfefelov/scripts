#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=12.1
readonly STUFF=netbeans-$VERSION-bin.zip

readonly TARGET_DIR=$HOME/dev/netbeans
mkdir --parents $TARGET_DIR

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://downloads.apache.org/netbeans/netbeans/$VERSION/$STUFF
  echo done

  echo -n Extracting...
  unzip -qq $STUFF
  echo done

  echo -n Installing...
  mv --force netbeans/* $TARGET_DIR
  chmod +x $TARGET_DIR/bin/netbeans
  echo done
)
rm --recursive --force $TEMP_DIR
