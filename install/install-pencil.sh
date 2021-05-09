#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

readonly VERSION=3.1.0.ga
readonly STUFF=pencil_${VERSION}_amd64.deb

sudo apt-get -qq update
sudo apt-get -qq install libgconf-2-4

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://pencil.evolus.vn/dl/V3.1.0.ga/$STUFF
  echo done

  echo -n Installing...
  dpkg --install $STUFF
  echo done
)
rm --recursive --force $TEMP_DIR
