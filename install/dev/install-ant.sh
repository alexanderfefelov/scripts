#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=ant
readonly VERSION=1.10.11
readonly STUFF=apache-ant-$VERSION-bin.tar.gz
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
  wget --quiet https://downloads.apache.org/ant/binaries/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force apache-ant-$VERSION/* $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "export ANT_HOME=$TARGET_DIR
export PATH=\$ANT_HOME/bin:\$PATH" > $HOME/.profile.d/$MONIKER.sh
echo done
