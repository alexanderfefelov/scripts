#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=8-update9
readonly STUFF=xmind-$VERSION-linux.zip
readonly TARGET_DIR=$HOME/programs/xmind
readonly START_SCRIPT=$TARGET_DIR/start-xmind.sh

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR
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
  echo $TARGET_DIR/XMind_amd64/XMind \
-configuration $TARGET_DIR/XMind_amd64/configuration \
-data $TARGET_DIR/workspace \
'"$@"' > $START_SCRIPT
  chmod +x $START_SCRIPT
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "-Duser.language=en" >> $TARGET_DIR/XMind_amd64/XMind.ini
echo done
