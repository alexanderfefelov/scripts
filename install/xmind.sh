#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=8-update9
readonly STUFF=xmind-$VERSION-linux.zip

readonly TARGET_DIR=$HOME/programs/xmind
mkdir --parents $TARGET_DIR
readonly START_SCRIPT=$TARGET_DIR/start-xmind.sh

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://www.xmind.net/xmind/downloads/$STUFF
  echo done

  echo -n Extracting...
  unzip -qq $STUFF -d dist
  echo done

  echo -n Installing...
  mv --force dist/* $TARGET_DIR
  echo '"$(dirname "$(realpath "$0")")"/XMind_amd64/XMind \
-configuration "$(dirname "$(realpath "$0")")"/XMind_amd64/configuration \
-data "$(dirname "$(realpath "$0")")"/workspace \
"$@"
' > $START_SCRIPT
  chmod +x $START_SCRIPT
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "-Duser.language=en" >> $TARGET_DIR/XMind_amd64/XMind.ini
echo done
