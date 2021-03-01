#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=visual-paradigm
readonly STUFF=Visual_Paradigm_CE_Linux64.sh
readonly TARGET_DIR=$HOME/dev/$MONIKER

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR
readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://www.visual-paradigm.com/downloads/vpce/$STUFF
  echo done

  echo -n Installing...
  chmod +x $STUFF
  ./$STUFF -q -dir $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR
