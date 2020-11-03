#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=1.10.1.727
readonly STUFF=linux-install-$VERSION.sh

readonly TARGET_DIR=$HOME/dev/clojure
mkdir --parents $TARGET_DIR

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://download.clojure.org/install/$STUFF
  echo done

  echo -n Installing...
  chmod +x $STUFF
  ./$STUFF --prefix $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
sudo cp --force .profile.d.sh /etc/profile.d/profile.d.sh
mkdir --parents $HOME/.profile.d
echo "export CLOJURE_HOME=$TARGET_DIR
export PATH=\$CLOJURE_HOME/bin:\$PATH" > $HOME/.profile.d/clojure.sh
echo done
