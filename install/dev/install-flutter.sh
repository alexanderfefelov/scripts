#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=flutter
readonly VERSION=1.22.6
readonly STUFF=flutter_linux_$VERSION-stable.tar.xz
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
  wget --quiet https://storage.googleapis.com/flutter_infra/releases/stable/linux/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --file=$STUFF
  echo done

  echo -n Installing...
  shopt -s dotglob && mv --force flutter/* $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "export FLUTTER_HOME=$TARGET_DIR
export PATH=\$FLUTTER_HOME/bin:\$PATH" > $HOME/.profile.d/$MONIKER.sh
echo done
