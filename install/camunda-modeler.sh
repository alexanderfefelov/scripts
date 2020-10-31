#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=4.3.0
readonly STUFF=camunda-modeler-$VERSION-linux-x64.tar.gz

readonly TARGET_DIR=$HOME/programs/camunda-modeler
mkdir --parents $TARGET_DIR

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://downloads.camunda.cloud/release/camunda-modeler/$VERSION/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force camunda-modeler-$VERSION-linux-x64/* $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR
