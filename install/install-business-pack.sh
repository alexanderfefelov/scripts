#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=business-pack
readonly STUFF=bpsetup.exe
readonly EXE=bp.exe
readonly TARGET_DIR=$HOME/programs/$MONIKER
readonly START_SCRIPT=$TARGET_DIR/start-$MONIKER.sh

create_start_script() {
  echo wine $TARGET_DIR/$EXE > $START_SCRIPT
  chmod +x $START_SCRIPT
}

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR
readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://pvision.ru/download/bp7/$STUFF
  echo done

  echo -n Installing...
  wine $STUFF /VERYSILENT /NOICONS /DIR="z:$TARGET_DIR"
  create_start_script
  echo done
)
rm --recursive --force $TEMP_DIR
