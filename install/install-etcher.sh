#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=etcher
readonly VERSION=1.5.109
readonly STUFF=balenaEtcher-$VERSION-x64.AppImage
readonly INSTALLER_DIR=$(dirname "$(realpath "$0")")
readonly TARGET_DIR=$HOME/programs/$MONIKER

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Utility;
Name=Etcher
Comment=
Icon=$TARGET_DIR/etcher.png
Exec=$TARGET_DIR/$MONIKER
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR

wget --quiet --output-document=$TARGET_DIR/$MONIKER https://github.com/balena-io/etcher/releases/download/v$VERSION/$STUFF
chmod +x $TARGET_DIR/$MONIKER
cp --force $INSTALLER_DIR/etcher.png $TARGET_DIR
create_desktop_entry
