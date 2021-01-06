#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=dylan
readonly VERSION=2020.1
readonly STUFF=opendylan-$VERSION-x86_64-linux.tar.bz2
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
  wget --quiet https://github.com/dylan-lang/opendylan/releases/download/v$VERSION.0/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --file=$STUFF
  echo done

  echo -n Installing...
  mv --force opendylan-$VERSION/* $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "export DYLAN_HOME=$TARGET_DIR
export PATH=\$DYLAN_HOME/bin:\$PATH" > $HOME/.profile.d/$MONIKER.sh
echo done
