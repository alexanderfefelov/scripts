#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=1.4.10
readonly STUFF=kotlin-compiler-$VERSION.zip

readonly TARGET_DIR=$HOME/dev/kotlin
mkdir --parents $TARGET_DIR

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://github.com/JetBrains/kotlin/releases/download/v$VERSION/$STUFF
  echo done

  echo -n Extracting...
  unzip -qq $STUFF
  echo done

  echo -n Installing...
  mv --force kotlinc/* $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
sudo cp --force .profile.d.sh /etc/profile.d/profile.d.sh
mkdir --parents $HOME/.profile.d
echo 'export KOTLIN_HOME=$HOME/dev/kotlin
export PATH=$KOTLIN_HOME/bin:$PATH
' > $HOME/.profile.d/kotlin.sh
echo done