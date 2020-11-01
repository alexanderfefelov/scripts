#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=3.0.6
readonly STUFF=apache-groovy-binary-$VERSION.zip

readonly TARGET_DIR=$HOME/dev/groovy
mkdir --parents $TARGET_DIR

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://dl.bintray.com/groovy/maven/$STUFF
  echo done

  echo -n Extracting...
  unzip -qq $STUFF
  echo done

  echo -n Installing...
  mv --force groovy-$VERSION/* $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
sudo cp --force .profile.d.sh /etc/profile.d/profile.d.sh
mkdir --parents $HOME/.profile.d
echo 'export GROOVY_HOME=$HOME/dev/groovy
export PATH=$GROOVY_HOME/bin:$PATH
' > $HOME/.profile.d/groovy.sh
echo done
