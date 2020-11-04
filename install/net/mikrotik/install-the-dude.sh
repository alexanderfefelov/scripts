#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=the-dude
readonly VERSION=4.0beta3
readonly STUFF=dude-install-$VERSION.exe
readonly INSTALLER_DIR=$(dirname "$(realpath "$0")")
readonly TARGET_DIR=$HOME/programs/mikrotik/$MONIKER
readonly START_SCRIPT=$TARGET_DIR/start-$MONIKER.sh

create_start_script() {
  echo cd $TARGET_DIR '&&' wine dude.exe > $START_SCRIPT
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
  wget --quiet https://github.com/alexanderfefelov/docker-dude/raw/master/installer/$STUFF
  echo done

  echo -n Extracting...
  7z x -odude \
    -x!uninstall.exe \
    $STUFF > /dev/null
  echo done

  echo -n Installing...
  mv --force dude/* $TARGET_DIR
  cp --force $INSTALLER_DIR/$MONIKER.ico $TARGET_DIR
  create_start_script
  echo done
)
rm --recursive --force $TEMP_DIR
