#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=3.5.17
readonly STUFF=Balsamiq_Mockups_${VERSION}_bundled.zip

readonly TARGET_DIR=$HOME/programs/balsamiq-mockups
mkdir --parents $TARGET_DIR
readonly START_SCRIPT=$TARGET_DIR/start-balsamiq-mockups.sh

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://build_archives.s3.amazonaws.com/obsolete/mockups-desktop/$VERSION/$STUFF
  echo done

  echo -n Extracting...
  unzip -qq $STUFF
  echo done

  echo -n Installing...
  mv --force Balsamiq_Mockups_3/* $TARGET_DIR
  echo wine $TARGET_DIR/'Balsamiq\ Mockups\ 3.exe' '"$@"' > $START_SCRIPT
  chmod +x $START_SCRIPT
  echo done
)
rm --recursive --force $TEMP_DIR
