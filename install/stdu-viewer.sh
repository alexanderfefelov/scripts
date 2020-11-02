#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

STUFF=stduviewer.zip

readonly TARGET_DIR=$HOME/programs/stdu-viewer
mkdir --parents $TARGET_DIR
echo $TARGET_DIR
readonly START_SCRIPT=$TARGET_DIR/start-stdu-viewer.sh

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet http://www.stdutility.com/download/$STUFF
  echo done

  echo -n Extracting...
  unzip -qq $STUFF -d dist
  echo done

  echo -n Installing...
  mv --force dist/* $TARGET_DIR
  chmod +x $TARGET_DIR/STDUViewerApp.exe
  echo 'wine "$(dirname "$(realpath "$0")")"/STDUViewerApp.exe "$@"' > $START_SCRIPT
  chmod +x $START_SCRIPT
  echo done
)
rm --recursive --force $TEMP_DIR
