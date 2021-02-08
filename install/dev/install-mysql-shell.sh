#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=mysql-shell
readonly VERSION=8.0.23
readonly STUFF=mysql-shell-$VERSION-linux-glibc2.12-x86-64bit.tar.gz
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
  wget --quiet https://dev.mysql.com/get/Downloads/MySQL-Shell/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force mysql-shell-$VERSION-linux-glibc2.12-x86-64bit/* $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "export MYSQL_SHELL_HOME=$TARGET_DIR
export PATH=\$MYSQL_SHELL_HOME/bin:\$PATH" > $HOME/.profile.d/$MONIKER.sh
echo done
