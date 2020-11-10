#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=dotnet-core-sdk
readonly VERSION=5.0.100
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
  wget --quiet https://download.visualstudio.microsoft.com/download/pr/820db713-c9a5-466e-b72a-16f2f5ed00e2/628aa2a75f6aa270e77f4a83b3742fb8/$STUFF
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
export PATH=\$DOTNET_CORE_SDK_HOME:\$PATH

export DOTNET_ROOT=\$DOTNET_CORE_SDK_HOME" > $HOME/.profile.d/$MONIKER.sh
echo done

$TARGET_DIR/dotnet --info
