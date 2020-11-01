#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=7.2.3
readonly STUFF=dbeaver-ce-$VERSION-linux.gtk.x86_64.tar.gz

readonly TARGET_DIR=$HOME/dev/dbeaver
mkdir --parents $TARGET_DIR

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://github.com/dbeaver/dbeaver/releases/download/$VERSION/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force dbeaver/* $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "-Duser.language=en" >> $TARGET_DIR/dbeaver.ini
echo done
