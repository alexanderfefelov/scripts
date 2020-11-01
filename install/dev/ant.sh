#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=1.10.9
readonly STUFF=apache-ant-$VERSION-bin.tar.gz

readonly TARGET_DIR=$HOME/dev/ant
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
sudo cp --force .profile.d.sh /etc/profile.d/profile.d.sh
mkdir --parents $HOME/.profile.d
echo 'export ANT_HOME=$HOME/dev/ant
export PATH=$ANT_HOME/bin:$PATH
' > $HOME/.profile.d/ant.sh
echo done
