#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=1.15.3
readonly STUFF=go$VERSION.linux-amd64.tar.gz

readonly TARGET_DIR=$HOME/dev/go
mkdir --parents $TARGET_DIR

readonly WORKSPACE=$HOME/projects/go
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
sudo cp --force .profile.d.sh /etc/profile.d/profile.d.sh
mkdir --parents $HOME/.profile.d
echo 'export GO_HOME=$HOME/dev/go
export PATH=$GO_HOME/bin:$PATH

export GOROOT=$GO_HOME
export GOPATH=$HOME/projects/go
' > $HOME/.profile.d/go.sh
echo done
