#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=dotnet-core-sdk
readonly VERSION=5.0.102
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

  wget --quiet https://download.visualstudio.microsoft.com/download/pr/7f736160-9f34-4595-8d72-13630c437aef/b9c4513afb0f8872eb95793c70ac52f6/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF --directory=$TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "export DOTNET_CORE_SDK_HOME=$TARGET_DIR
export PATH=\$DOTNET_CORE_SDK_HOME:\$PATH

export DOTNET_ROOT=\$DOTNET_CORE_SDK_HOME" > $HOME/.profile.d/$MONIKER.sh
echo done

$TARGET_DIR/dotnet --info
