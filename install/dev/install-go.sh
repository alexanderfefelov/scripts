#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=go
readonly VERSION=1.16.3
readonly STUFF=go$VERSION.linux-amd64.tar.gz
readonly TARGET_DIR=$HOME/dev/$MONIKER
readonly WORKSPACE=$HOME/projects/$MONIKER

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR
mkdir --parents $WORKSPACE
readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://golang.org/dl/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force go/* $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "export GO_HOME=$TARGET_DIR
export PATH=\$GO_HOME/bin:\$PATH

export GOROOT=\$GO_HOME
export GOPATH=$WORKSPACE" > $HOME/.profile.d/$MONIKER.sh
echo done
