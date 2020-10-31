#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=20.2.0
readonly BASE=graalvm-ce-java11
readonly STUFF=$BASE-linux-amd64-$VERSION.tar.gz

readonly TARGET_DIR=$HOME/dev/jdk
mkdir --parents $TARGET_DIR

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$VERSION/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force $BASE-$VERSION $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
ln --symbolic $TARGET_DIR/$BASE-$VERSION $TARGET_DIR/default
sudo cp --force .profile.d.sh /etc/profile.d/profile.d.sh
mkdir --parents $HOME/.profile.d
echo 'export JAVA_HOME=$HOME/dev/jdk/default
export PATH=$JAVA_HOME/bin:$PATH
' > $HOME/.profile.d/jdk.sh
echo done
