#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

STUFF=skypeforlinux-64.deb

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://repo.skype.com/latest/$STUFF
  echo done

  echo -n Installing...
  dpkg --install $STUFF
  echo done
)
rm --recursive --force $TEMP_DIR
