#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

VERSION=4.0beta3
STUFF=dude-install-$VERSION.exe

readonly TARGET_DIR=$HOME/programs/mikrotik/the-dude
mkdir --parents $TARGET_DIR
readonly START_SCRIPT=$TARGET_DIR/start-the-dude.sh

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
  chmod +x $TARGET_DIR/dude.exe
  echo 'cd "$(dirname "$(realpath "$0")")" && wine dude.exe' > $START_SCRIPT
  chmod +x $START_SCRIPT
  echo done
)
rm --recursive --force $TEMP_DIR

cp --force the-dude.ico $TARGET_DIR
