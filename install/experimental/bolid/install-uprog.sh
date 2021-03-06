#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=uprog
readonly VERSION=4.1.5.10498
readonly STUFF=InstallUProg_$VERSION.exe
readonly TARGET_DIR=$HOME/programs/bolid/$MONIKER
readonly START_SCRIPT=$TARGET_DIR/start-$MONIKER.sh
readonly UPROG_DIR=$TARGET_DIR/drive_c/uprog
readonly EXE=UProg.exe

create_start_script() {
  echo cd $UPROG_DIR > $START_SCRIPT
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
  wget --quiet https://github.com/alexanderfefelov/orion-uprog-dist/raw/main/$STUFF
  echo done

  echo -n Extracting...
  innoextract --extract $STUFF > /dev/null
  echo done

  echo -n Installing...
  mkdir --parents $UPROG_DIR
  mv --force 'code$GetExePath'/* $UPROG_DIR
  create_start_script
  echo done
)
rm --recursive --force $TEMP_DIR
