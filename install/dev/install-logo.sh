#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=logo

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Development;
Name=Berkeley Logo
Comment=
Icon=ucblogo
Exec=logo
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

sudo apt-get -qq update
sudo apt-get -qq install ucblogo
create_desktop_entry
