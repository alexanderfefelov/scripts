#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=deskreen
readonly VERSION=1.0.11
readonly STUFF=Deskreen-$VERSION.AppImage

readonly INSTALLER_DIR=$(dirname "$(realpath "$0")")
readonly TARGET_DIR=$HOME/programs/$MONIKER

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Utility;
Name=Deskreen
Comment=
Icon=$TARGET_DIR/deskreen.png
Exec=$TARGET_DIR/deskreen
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR

wget --quiet --output-document=$TARGET_DIR/deskreen https://github.com/pavlobu/deskreen/releases/download/v$VERSION/$STUFF
chmod +x $TARGET_DIR/$MONIKER
cp --force $INSTALLER_DIR/deskreen.png $TARGET_DIR
create_desktop_entry
