#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=pprog
readonly VERSION=3.13.50.10337
readonly STUFF=instpprog_$VERSION.exe
readonly TARGET_DIR=$HOME/programs/bolid/$MONIKER
readonly START_SCRIPT=$TARGET_DIR/start-$MONIKER.sh
readonly PPROG_DIR=$TARGET_DIR/drive_c/pprog
readonly EXE=PProg.exe

create_start_script() {
  echo cd $PPROG_DIR > $START_SCRIPT
  echo WINEPREFIX=$TARGET_DIR WINEARCH=win32 wine $EXE >> $START_SCRIPT
  chmod +x $START_SCRIPT
}

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR

WINEPREFIX=$TARGET_DIR WINEARCH=win32 wineboot

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://github.com/alexanderfefelov/orion-pprog-dist/raw/main/$STUFF
  echo done

  echo -n Extracting...
  innoextract --extract $STUFF > /dev/null
  echo done

  echo -n Installing...
  mkdir --parents $PPROG_DIR
  mv --force app/* $PPROG_DIR
  create_start_script
  echo done
)
rm --recursive --force $TEMP_DIR
