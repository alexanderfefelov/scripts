#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=dotnet-sdk
readonly VERSION=5.0.203
readonly STUFF=dotnet-sdk-$VERSION-linux-x64.tar.gz
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
  wget --quiet https://download.visualstudio.microsoft.com/download/pr/ef13f9da-46dc-4de9-a05e-5a4c20574189/be95913ebf1fb6c66833ca40060d3f65/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF --directory=$TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "export DOTNET_SDK_HOME=$TARGET_DIR
export PATH=\$DOTNET_SDK_HOME:\$HOME/.dotnet/tools:\$PATH

export DOTNET_ROOT=\$DOTNET_SDK_HOME" > $HOME/.profile.d/$MONIKER.sh
echo done

$TARGET_DIR/dotnet --info
