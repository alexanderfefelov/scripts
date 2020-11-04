#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=3.6.3
readonly STUFF=apache-maven-$VERSION-bin.tar.gz
readonly TARGET_DIR=$HOME/dev/maven

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR
readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://downloads.apache.org/maven/maven-3/$VERSION/binaries/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force apache-maven-$VERSION/* $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
sudo cp --force .profile.d.sh /etc/profile.d/profile.d.sh
mkdir --parents $HOME/.profile.d
echo "export MAVEN_HOME=$TARGET_DIR
export PATH=\$MAVEN_HOME/bin:\$PATH" > $HOME/.profile.d/maven.sh
echo done
