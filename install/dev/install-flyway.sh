#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=flyway
readonly VERSION=7.8.1
readonly STUFF=flyway-commandline-$VERSION-linux-x64.tar.gz
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
  wget --quiet https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/$VERSION/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force flyway-$VERSION/* $TARGET_DIR
  ln --force --symbolic $TARGET_DIR/flyway $HOME/bin/flyway
  echo done
)
rm --recursive --force $TEMP_DIR
