#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=3.20.1
readonly STUFF=yEd-$VERSION.zip
readonly TARGET_DIR=$HOME/programs/yed
readonly START_SCRIPT=$TARGET_DIR/start-yed.sh

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR
readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://yworks.com/resources/yed/demo/$STUFF
  echo done

  echo -n Extracting...
  unzip -qq $STUFF
  echo done

  echo -n Installing...
  mv --force yed-$VERSION/* $TARGET_DIR
  echo java -jar $TARGET_DIR/yed.jar '"$@"' > $START_SCRIPT
  chmod +x $START_SCRIPT
  echo done
)
rm --recursive --force $TEMP_DIR
