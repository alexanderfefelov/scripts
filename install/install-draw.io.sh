#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=draw.io
readonly VERSION=14.5.1
readonly STUFF=drawio-x86_64-$VERSION.AppImage
readonly INSTALLER_DIR=$(dirname "$(realpath "$0")")
readonly TARGET_DIR=$HOME/programs/$MONIKER

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Office;
Name=draw.io
Comment=
Icon=$TARGET_DIR/draw.io.png
Exec=$TARGET_DIR/draw.io
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR
wget --quiet --output-document=$TARGET_DIR/draw.io https://github.com/jgraph/drawio-desktop/releases/download/v$VERSION/$STUFF
chmod +x $TARGET_DIR/draw.io
cp --force $INSTALLER_DIR/draw.io.png $TARGET_DIR
create_desktop_entry
