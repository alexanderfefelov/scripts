#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

STUFF=winbox64
EXE=$STUFF.exe

readonly TARGET_DIR=$HOME/programs/mikrotik/winbox
mkdir --parents $TARGET_DIR
readonly START_SCRIPT=$TARGET_DIR/start-winbox.sh

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://mt.lv/$STUFF
  echo done

  echo -n Installing...
  mv --force  $STUFF $TARGET_DIR/$EXE
  echo wine $TARGET_DIR/$EXE > $START_SCRIPT
  chmod +x $START_SCRIPT
  echo done
)
rm --recursive --force $TEMP_DIR

cp --force winbox.ico $TARGET_DIR
