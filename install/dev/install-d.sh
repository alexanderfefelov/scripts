#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=d
readonly VERSION=2.096.0
readonly STUFF=dmd.$VERSION.linux.tar.xz
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
  wget --quiet https://s3.us-west-2.amazonaws.com/downloads.dlang.org/releases/2021/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --file=$STUFF
  echo done

  echo -n Installing...
  mv --force dmd2/* $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "export D_HOME=$TARGET_DIR
export PATH=\$D_HOME/linux/bin64:\$PATH" > $HOME/.profile.d/$MONIKER.sh
echo done
