#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=calibre
readonly INSTALLER_DIR=$(dirname "$(realpath "$0")")
readonly TARGET_DIR=$HOME/programs/$MONIKER

create_desktop_entries() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Office;
Name=calibre
Comment=
Icon=$TARGET_DIR/calibre.png
Exec=$TARGET_DIR/calibre %u
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop

  echo "[Desktop Entry]
Type=Application
Categories=Office;
Name=calibre E-book Viewer
Comment=
Icon=$TARGET_DIR/resources/images/viewer.png
Exec=$TARGET_DIR/ebook-viewer %u
Terminal=false" > $HOME/.local/share/applications/$MONIKER-viewer.desktop
}

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

wget --quiet --output-document=- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin install_dir=$HOME/programs isolated=y
cp --force $INSTALLER_DIR/calibre.png $TARGET_DIR
create_desktop_entries
