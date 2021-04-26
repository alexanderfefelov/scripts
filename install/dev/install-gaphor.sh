#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=gaphor
readonly VERSION=2.2.2
readonly STUFF=Gaphor-$VERSION-x86_64.AppImage
readonly INSTALLER_DIR=$(dirname "$(realpath "$0")")
readonly TARGET_DIR=$HOME/dev/$MONIKER

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Development;
Name=Gaphor
Comment=
Icon=$TARGET_DIR/gaphor.png
Exec=$TARGET_DIR/gaphor
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR
wget --quiet --output-document=$TARGET_DIR/gaphor https://github.com/gaphor/gaphor/releases/download/$VERSION/$STUFF
chmod +x $TARGET_DIR/gaphor
cp --force $INSTALLER_DIR/gaphor.png $TARGET_DIR
create_desktop_entry
