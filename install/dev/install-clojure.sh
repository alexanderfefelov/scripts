#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=clojure
readonly VERSION=1.10.3.814
readonly STUFF=linux-install-$VERSION.sh
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
  wget --quiet https://download.clojure.org/install/$STUFF
  echo done

  echo -n Installing...
  chmod +x $STUFF
  ./$STUFF --prefix $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "export CLOJURE_HOME=$TARGET_DIR
export PATH=\$CLOJURE_HOME/bin:\$PATH" > $HOME/.profile.d/$MONIKER.sh
echo done
