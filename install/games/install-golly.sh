#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=golly
readonly VERSION=4.0
readonly STUFF=golly-$VERSION-gtk-64bit.tar.gz
readonly INSTALLER_DIR=$(dirname "$(realpath "$0")")
readonly TARGET_DIR=$HOME/programs/$MONIKER

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Game;
Name=Golly
Comment=
Icon=$TARGET_DIR/golly.ico
Exec=$TARGET_DIR/golly %u
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

mkdir --parents $TARGET_DIR
readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://sourceforge.net/projects/golly/files/golly/golly-$VERSION/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force golly-$VERSION-gtk-64bit/* $TARGET_DIR
  cp --force $INSTALLER_DIR/golly.ico $TARGET_DIR
  create_desktop_entry
  echo done
)
rm --recursive --force $TEMP_DIR
