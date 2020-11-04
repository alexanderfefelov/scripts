#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=dotnet-core-sdk
readonly VERSION=3.1.109
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
  wget --quiet https://download.visualstudio.microsoft.com/download/pr/401ae772-3b16-40c7-a332-e7c0622c97fd/58016e724bc0dfa0c1f2ef0233b95aed/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF --directory=$TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
sudo cp --force .profile.d.sh /etc/profile.d/profile.d.sh
mkdir --parents $HOME/.profile.d
echo "export DOTNET_CORE_SDK_HOME=$TARGET_DIR
export PATH=$DOTNET_CORE_SDK_HOME:$PATH" > $HOME/.profile.d/$MONIKER.sh
echo done

$TARGET_DIR/dotnet --info
